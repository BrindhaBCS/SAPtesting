"""
This file is used to build and update the Robot Framework project
"""
import argparse
from genericpath import isdir
import os
import platform
import shutil
import stat
import subprocess
import sys
from robot_code_updater import RobotUpdater
from Robot_Scripts_Setup.Requirements.install_dependencies import DependencyHandler
from Robot_Scripts_Setup.Execution import Access_data_function
import logger_handler
import variables


class Builder(object):
    """
    Controls Robot framework project space creation. This can then be handled inside
    another git repository.
    """
    def __init__(self):
        self.logger = logger_handler.setup('Robot_Generator')
        self.args = self._parse_arguments()
        self.dependency_handler = DependencyHandler(self.args.location)
        self.python_version = self.dependency_handler.get_python_version()
        self.enhance_folders = []

    @staticmethod
    def _parse_arguments():
        """
        Gets user arguments to build the starting project for Robot Framework
        """
        parser = argparse.ArgumentParser("Robot Framework Project Creator Arguments")
        parser.add_argument("-n", "--project_name", help="Project Name",
                            default="Project")
        parser.add_argument("-t", "--project_type", nargs="+",
                            help="Type of the project to create. Can be more than one.",
                            default=["Web"],
                            choices=["Web", "Mobile", "Database", "API", "Salesforce"])
        parser.add_argument("-e", "--enhance_existing", action="store_true",
                            help="Enhance existing project space rather than creating new.")
        parser.add_argument("-c", "--project_capabilities", nargs="+",
                            help="Project capabilities to install",
                            default=[], choices=["Excel"])
        parser.add_argument("-nvenv", "--no_virtual_environment", action='store_true',
                            help="Pass this parameter if no virtual environment is to be used.")
        parser.add_argument("-l", "--location", help="Folder path to the project")
        args = parser.parse_args(sys.argv[1:])
        args.project_type = [l.lower() for l in args.project_type]
        args.project_capabilities = [l.lower() for l in args.project_capabilities]
        return args

    def create_folder(self, folder_path):
        """
        Creates a folder if it does not exist.
        :param folder_path: Folder path to be created
        """
        if os.path.isdir(folder_path):
            if os.listdir(folder_path):
                return
        else:
            self.logger.info("Creating directory: %s", folder_path)
            os.makedirs(folder_path)

    def create_project_folder(self):
        """
        Creates project location directory."
        """
        self.logger.info("Creating project directory location")
        self.create_folder(self.args.location)

    @staticmethod
    def _copy_files_when_dir_dont_exist(source_dir, target_dir, ignore_pattern_list=None):
        """
        Copies source to target allowing overwrite
        :param source_dir: Source directory containing files
        :param target_dir: Target directory to copy files to
        :param ignore_pattern_list: Pattern to ignore if any
        """
        if ignore_pattern_list:
            ignore_pattern_list = shutil.ignore_patterns(*ignore_pattern_list)
        shutil.copytree(source_dir, target_dir, ignore=ignore_pattern_list)

    @staticmethod
    def _make_dir_if_path_does_not_exist(directory_path):
        """
        Creates directory path if it does not already exist
        :param directory_path: Path to check and create
        """
        if not os.path.exists(directory_path):
            os.makedirs(directory_path)

    @staticmethod
    def _create_file_based_on_existence(dst_dir, dst_file, src_file, overwrite):
        """
        Create file based on existence and overwrite value
        :param dst_dir:
        :param dst_file: Target path to file
        :param src_file: Source path of file
        :param overwrite: Check if file is to be overwritten
        """
        if os.path.exists(dst_file):
            try:
                if overwrite:
                    os.remove(dst_file)
                    shutil.copy(src_file, dst_dir)
            except PermissionError:
                if overwrite:
                    os.chmod(dst_file, stat.S_IWUSR)
                    os.remove(dst_file)
                    shutil.copy(src_file, dst_dir)
        else:
            shutil.copy(src_file, dst_dir)

    def _copy_files_when_dir_exist(self, source_dir, target_dir, overwrite=True):
        """
        Copies source to target directory when target directory pre-exists
        :param source_dir: Source directory path to copy files from
        :param target_dir: Target directory path to paste files into
        :param overwrite: Overwrites the file if exists, else skips update when file exists
        """
        for src_dir, _, files in os.walk(source_dir):
            dst_dir = src_dir.replace(source_dir, target_dir, 1)
            self._make_dir_if_path_does_not_exist(dst_dir)
            for file_ in files:
                src_file = os.path.join(src_dir, file_)
                dst_file = os.path.join(dst_dir, file_)
                self._create_file_based_on_existence(dst_dir, dst_file, src_file, overwrite)

    def _copy_overwrite_files(self, source_dir, target_dir,
                              ignore_pattern_list=None, overwrite=True):
        """
        Copies files from source to target directory. Overwrites contents in case of conflict
        by deleting the file and recreating it.
        :param source_dir: Source directory path to copy files from
        :param target_dir: Target directory path to paste files into
        :param ignore_pattern_list: Patterns to ignore while copying files
        :param overwrite: Overwrites the file if exists, else skips update when file exists
        """

        if not os.path.exists(target_dir):
            self._copy_files_when_dir_dont_exist(source_dir, target_dir, ignore_pattern_list)
        else:
            self._copy_files_when_dir_exist(source_dir, target_dir, overwrite)

    @staticmethod
    def _get_file_lines(file_path):
        """
        Reads file data and returns all lines in it.
        :param file_path: File path to be read for lines
        :return: individual file lines in a list type
        """
        file_lines = []
        with open(file_path, "r") as file_object:
            for line in file_object.readlines():
                line = line.strip()
                if line:
                    file_lines.append(line)
        return file_lines

    def _get_requirements_on_project(self):
        """
        Fetches requirements based on user requirements
        specified for the project.
        """
        # Project type dependencies
        arguments = []
        if "web" in self.args.project_type:
            arguments.extend(["-s"])
        if "mobile" in self.args.project_type:
            arguments.append("-a")
        if "api" in self.args.project_type:
            arguments.append("-rq")
        if "excel" in self.args.project_capabilities:
            arguments.append("-e")
        if "database" in self.args.project_type:
            arguments.append("-db")
        if "salesforce" in self.args.project_type:
            arguments.append("-sl")

        self.dependency_handler.parse_arguments(arguments)
        return self.dependency_handler.get_requirement_arguments()

    def _update_requirements(self, file_path, existing=False):
        """
        Updates requirement in requirements.txt file
        :param file_path: The path to requirements file
        :param existing: Boolean check if requirement already exists or not
        :return:
        """
        # Get actual requirements
        requirement_list = self._get_requirements_on_project()
        # Add any missing ones
        if existing:
            # Get existing requirements
            current_dependencies = self._get_file_lines(file_path)
            # Find unique set of requirements with latest version numbers
            requirement_list = self._combine_requirements(requirement_list, current_dependencies)
        with open(file_path, "w") as file_object:
            file_object.write("\n".join(requirement_list))

    def _combine_requirements(self, requirements_project, existing_requirements):
        """
        Combines the requirements listed in two different files into one requirement list
        :param requirements_project: Requirements to be added to project
        :param existing_requirements: Existing requirements inside the project
        :return: Unique list of requirements with higher version number for each
        """
        requirements_project.extend(existing_requirements)
        requirements_project = self.dependency_handler.select_latest_requirements(
            requirements_project)

        requirements_project = [item.strip() for item in requirements_project
                                if item and item != "\n"]
        return sorted(list(set(requirements_project)))

    def _create_dependencies_folder(self):
        """
        Creates dependencies requirements for the project
        """
        self.logger.info("Creating dependencies directory:")
        dependency_dir = os.sep.join([self.args.location, "dependencies"])
        self.create_folder(dependency_dir)
        self.logger.info("Updating requirements.txt file.")
        req_file_path = os.sep.join([dependency_dir, "requirements.txt"])
        existing = False
        if os.path.isfile(req_file_path):
            existing = True
        self._update_requirements(req_file_path, existing=existing)

    def _read_and_create_file(self, original_file, final_file, substitute_dict=None,
                              overwrite=True):
        """
        Reads original file from Robot_Scripts_Setup directory into project directory
        :param original_file: Original file to read
        :param final_file: Final file to be created from original file data
        :param substitute_dict: Substitute key value by value inside the dict for final file
        :param overwrite: Overwrites the file even if it exists
        """
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(dir_path, "Robot_Scripts_Setup",
                                 original_file)
        # Read file data
        with open(file_path, "r") as fileobject:
            file_data = fileobject.read()
        if substitute_dict:
            for key in substitute_dict:
                file_data = file_data.replace(key, substitute_dict[key])

        # Create updated file into execution folder
        final_file_path = os.path.join(self.args.location, final_file)
        update = True
        if os.path.isfile(final_file_path) and not overwrite:
            update = False
        if update:
            with open(final_file_path, "w") as file_object:
                file_object.write(file_data)

    def _add_gitignore_file(self):
        "Adds gitignore to project space."
        self._read_and_create_file("gitignore.txt", ".gitignore", overwrite=False)

    @staticmethod
    def _get_dir_list():
        """
        Gets list of hierarchal parent folders of current file
        """
        current_directory = os.path.dirname(os.path.abspath(__file__))
        parent_1_directory = os.path.join(current_directory, os.pardir)
        parent_2_directory = os.path.join(parent_1_directory, os.pardir)
        parent_3_directory = os.path.join(parent_2_directory, os.pardir)
        dir_list = [current_directory, parent_1_directory, parent_2_directory, parent_3_directory]
        return dir_list

    def _add_readme_md_file(self):
        "Adds Readme.md or Readme_Salesforce.md file to project space"
        readme_file = "Readme.md"
        file_path = os.sep.join(["Readme", readme_file])
        if "salesforce" in self.args.project_type:
            readme_file = "Readme_Salesforce.md"
        substitute_dict = {"<ProjectName>": self.args.project_name,
                           "<Version_Number>": self._get_jnj_robot_framework_version()}
        self._read_and_create_file(file_path, readme_file, substitute_dict)
        readme_file_list = ["Readme_EAT_Integration_Xray.md",
                            "Readme_EAT_Integration_qTest.md",
                            "Readme_JPM_Integration.md",
                            "Readme_Saucelabs.md",
                            "Readme_Kibana.md"]
        for readme_file in readme_file_list:
            file_path = os.sep.join(["Readme", readme_file])
            self._read_and_create_file(file_path, readme_file, substitute_dict)
        if "mobile" in self.args.project_type:
            readme_file = "Readme_ExecutionPhysicalDevice.md"
            file_path = os.sep.join(["Readme", readme_file])
            self._read_and_create_file(file_path, readme_file, substitute_dict)
        if "web" in self.args.project_type or "salesforce" in self.args.project_type:
            readme_file = "Readme_Applitools.md"
            file_path = os.sep.join(["Readme", readme_file])
            self._read_and_create_file(file_path, readme_file, substitute_dict)

    def _get_jnj_robot_framework_version(self):
        """
        Fetches Robot Framework release version number as string
        :return: Robot Framework release version number
        """
        robot_release_version = 'N/A'
        dir_list = self._get_dir_list()
        for directory in dir_list:
            init_file = os.sep.join([directory, "robot_version.py"])
            if os.path.exists(init_file):
                with open(init_file, "r") as file_object:
                    data = file_object.readlines()[0]
                    if 'version' in data:
                        robot_release_version = data.split("=")[1].strip()[1:-1]
                        break
        return robot_release_version

    def _get_import_lines(self):
        """
        Reads through the project types and creates required import lines.
        :return: Import line list of strings
        """
        import_lines = ""
        for project_type in self.args.project_type:
            area = project_type.capitalize()
            line = Access_data_function.ad_import_call.replace(variables.AREA_VAR_STRING, area)
            import_lines += line
        return import_lines.strip()

    def _get_project_specific_data_access_functions(self):
        """
        Creates secured and data access functions which are project area specific
        :return: Function lines in a list of strings
        """
        function_lines = ""
        for project_type in self.args.project_type:
            area = project_type.capitalize()
            line = Access_data_function.ad_project_data_access.replace(
                variables.AREA_VAR_STRING, area)
            line += Access_data_function.ad_project_data_access_secured.replace(
                variables.AREA_VAR_STRING, area)
            function_lines += line
        return function_lines.strip()

    def _get_variable_access_data(self):
        """
        Builds data for variable access data calls at the end of access data
        :return: Variable lines in a list of strings
        """
        variable_lines = ""
        for project_type in self.args.project_type:
            area = project_type.capitalize()
            first_char = area[:1].lower()
            line = Access_data_function.ad_variable_caller.replace(
                variables.AREA_VAR_STRING, area).replace("${first_char}", first_char)
            line += Access_data_function.ad_variable_caller_secured.replace(
                variables.AREA_VAR_STRING, area).replace("${first_char}", first_char)
            variable_lines += line
        return variable_lines

    def _update_data_access_file(self, execution_folder):
        """
        Updates the data folder files to be uploaded into the project.
        :param execution_folder: The folder path where execution scripts are to be created.
        """
        self.logger.info("Access Data file creation")
        # Read Access_Data.py template
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.sep.join([dir_path, "Robot_Scripts_Setup",
                                 "Execution", "Access_Data.py"])
        file_data = ""
        with open(file_path, "r") as file_object:
            file_data = file_object.read()

        # Substitute import values
        import_lines = self._get_import_lines()
        file_data = file_data.replace("${import data folders}", import_lines)

        # Build project specific data access functions
        data_access_function_lines = self._get_project_specific_data_access_functions()
        file_data = file_data.replace("${Project specific data access functions}",
                                      data_access_function_lines)

        # Build variable access data functions
        variable_access_data_lines = self._get_variable_access_data()
        file_data = file_data.replace("${Variable access calls}", variable_access_data_lines)

        # Create updated file into execution folder
        file_path = os.sep.join([execution_folder, "Access_Data.py"])
        with open(file_path, "w") as file_object:
            file_object.write(file_data)

    def create_execution_files(self):
        """
        Create Execution folder files
        """
        execution_folder = os.sep.join([self.args.location, "Execution"])
        self.logger.info("Creating Execution folder:")
        self.create_folder(execution_folder)
        self._update_copy_exact_files(execution_folder)
        self._update_data_access_file(execution_folder)

    def eat_integration_files(self):
        """
        Create EAT_Integration folder files
        """
        eat_folder = os.sep.join([self.args.location, "EAT_Integration"])
        self.logger.info("Creating EAT_Integration folder:")
        self.create_folder(eat_folder)
        self._update_copy_eat_integration_files(eat_folder)

    def jpm_template_files(self):
        """
        Create JPM Template folder files
        """
        jpm_folder = os.sep.join([self.args.location, "JPM Template"])
        self.logger.info("Creating JPM Template folder:")
        self.create_folder(jpm_folder)
        self._copy_jpm_template_files(jpm_folder)

    def _update_copy_exact_files(self, execution_folder):
        """
        Exact python files under Exact_Files folder to be copied to project
        execution folder location.
        :param execution_folder: Project folder where to create the driver data file
        """
        gsg_dir_path = os.path.dirname(os.path.realpath(__file__))
        exact_files_location = os.sep.join(
            [gsg_dir_path, "Robot_Scripts_Setup", "Execution", "Exact_Files"])
        for file_name in os.listdir(exact_files_location):
            file_path = os.sep.join([exact_files_location, file_name])
            if os.path.isfile(file_path):
                self.logger.info("%s file creation", file_name)
                shutil.copy(file_path, execution_folder)

    def _update_copy_eat_integration_files(self, eat_folder):
        """
        EAT_Integration folder to be copied to project execution folder location.
        :param execution_folder: Project folder containing test management tool files
        """
        gsg_dir_path = os.path.dirname(os.path.realpath(__file__))
        eat_integration_files_location = os.sep.join(
            [gsg_dir_path, "EAT_Integration"])
        if isdir(eat_folder):
            shutil.rmtree(eat_folder)
        shutil.copytree(eat_integration_files_location, eat_folder)

    def _copy_jpm_template_files(self, jpm_folder):
        """
        EAT_Integration folder to be copied to project execution folder location.
        :param execution_folder: Project folder containing test management tool files
        """
        gsg_dir_path = os.path.dirname(os.path.realpath(__file__))
        jpm_template_files_location = os.sep.join(
            [gsg_dir_path, "JPM_Template"])
        if isdir(jpm_folder):
            shutil.rmtree(jpm_folder)
        shutil.copytree(jpm_template_files_location, jpm_folder)

    def create_data_files(self):
        """
        Data folders will be as many as there are types of project specified.
        """
        self.logger.info("Creating Data files for the project:")
        data_folder = os.sep.join([self.args.location, "Data"])
        self.create_folder(data_folder)
        dir_path = os.path.dirname(os.path.realpath(__file__))

        # Create init file with no content
        init_file = os.sep.join([data_folder, "__init__.py"])
        open(init_file, 'a').close()

        for project_type in self.args.project_type:
            area = project_type.capitalize()
            area_folder = os.sep.join([data_folder, area])
            # Copy the normal data folder path to the area folder location.
            copy_data_folder = os.sep.join([dir_path, "Robot_Scripts_Setup",
                                            "Data", "Area"])
            self._copy_overwrite_files(copy_data_folder,
                                       area_folder, ignore_pattern_list=["*.pyc", "tmp*"],
                                       overwrite=False)

    def add_user_libraries(self):
        """
        Adds user libraries based on type of projects being worked at.
        Returns list of files under library that are now created.
        These will be added as library when the GSG is initialized.
        :returns: Library files to be added in a list
        """
        lib_folder = os.sep.join([self.args.location, "Library"])
        cur_dir_path = os.path.dirname(os.path.realpath(__file__))
        lib_path = os.sep.join([cur_dir_path, "Robot_Scripts_Setup", "Library"])
        self.logger.info("Creating Area specific library files:")
        for project_type in self.args.project_type:
            area = project_type.capitalize()
            area_lib_path = os.sep.join([lib_path, area])
            if self.args.enhance_existing:
                enhance_folder_location = os.path.join(
                    self.args.location, "Tests", area)
                self.enhance_folders.append(enhance_folder_location)
            if os.path.isdir(area_lib_path):
                self._copy_overwrite_files(area_lib_path, lib_folder, overwrite=False)
        lib_files = []
        if not os.path.isdir(lib_folder):
            os.mkdir(lib_folder)
        for filename in os.listdir(lib_folder):
            if filename.endswith(".py"):
                lib_files.append(filename)
        return lib_files

    @staticmethod
    def replace_file_data(file_path, replace_string, new_value):
        """
        Replaces content in file, in place, with the specified string.
        More than one substitutions allowed.
        :param file_path: File to be read and replace with new string values
        :param replace_string: The string to be found and replaced within the file
        :param new_value: New value to be substituted in the file.
        """
        with open(file_path, "r") as file_object:
            data = file_object.read()
        data = data.replace(replace_string, new_value)
        with open(file_path, "w") as file_object:
            file_object.write(data)

    def substitute_support_libraries(self, tests_folder, required_areas):
        """
        Substitutes required libraries for the tests in highest level support file
        :param tests_folder: Tests folder to be added to the project space
        :param required_areas: Areas that are to be added to project space
        :return:
        """
        project_libs = ""
        if "Web" in required_areas:
            project_libs += Access_data_function.ad_selenium_lib
        if "Mobile" in required_areas:
            project_libs += Access_data_function.ad_appium_lib
        if "Api" in required_areas:
            project_libs += Access_data_function.ad_api_lib
        if "Database" in required_areas:
            project_libs += Access_data_function.ad_db_lib
        support_file = os.sep.join([tests_folder, variables.SUPPORT_ROBOT])
        self.replace_file_data(support_file, "${Libraries Project Specific}",
                               project_libs)
        self.replace_file_data(support_file, "${Libraries Common}",
                               Access_data_function.common_libs)

    def create_tests_files(self, required_areas):
        """
        Creates tests file under Tests folder in the new project space as a starting point
        :param required_areas: Areas that are required to be populated data for
        """
        # Get directories
        self.logger.info("Creating Test folder files path:")
        tests_folder = os.sep.join([self.args.location, "Tests"])
        cur_dir_path = os.path.dirname(os.path.realpath(__file__))
        cur_dir_test_path = os.sep.join([cur_dir_path, "Robot_Scripts_Setup", "Tests"])

        # Copy highest level init files
        init_files_folder = os.sep.join([cur_dir_test_path, "Highest_Init"])
        self.logger.info("Creation of Tests folder highest level init files")
        self._copy_overwrite_files(init_files_folder, tests_folder)
        self.substitute_support_libraries(tests_folder, required_areas)
        # The following fixes the PABOTQUEUEINDEX issue for Salesforce.
        # Remove this when multi-threading is implemented for Salesforce.
        self.logger.info("self.args.project_type: %s", self.args.project_type)
        if "salesforce" in self.args.project_type:
            support_file_path = os.sep.join([cur_dir_path, "../tests/Proj_Salesforce/Tests"])
            self.logger.info("support_file_path: %s", support_file_path)
            self.logger.info("tests_folder: %s", tests_folder)
            self._copy_overwrite_files(support_file_path, tests_folder)

        # Build which test files to copy
        test_area_folders = []

        for area in required_areas:
            test_area_folders.append(os.sep.join([cur_dir_test_path, area]))
        sample_tests = os.sep.join([cur_dir_test_path, "Sample Tests", "Sample"])
        sample_target_folder = os.sep.join([tests_folder, "Sample"])
        self._copy_overwrite_files(sample_tests, sample_target_folder, overwrite=False)

        # Copy test files
        area_support = ""
        for test_area_folder in test_area_folders:
            area = test_area_folder.rsplit(os.sep, 1)[1]
            if os.path.exists(test_area_folder):
                self.logger.info("Creation of Tests %s folder files", area)
                self._copy_overwrite_files(test_area_folder, os.sep.join([tests_folder, area]))
            resource_file = Access_data_function.ad_resource_file.replace("$area", area)
            check_resource_file_path = resource_file.replace("/", os.sep).strip()
            if check_resource_file_path.strip().startswith("Resource"):
                check_resource_file_path = check_resource_file_path.replace("Resource", "").strip()
            if os.path.exists(os.sep.join([tests_folder, check_resource_file_path])):
                area_support += resource_file + Access_data_function.ad_newline

        support_file = os.sep.join([tests_folder, variables.SUPPORT_ROBOT])
        self.replace_file_data(support_file, "${Support Resources}", area_support)

    def create_sample_tests(self):
        """
        Creates sample starting point tests.
        """
        required_samples = []
        for area in self.args.project_type:
            required_samples.append(area.capitalize())
        for capability in self.args.project_capabilities:
            required_samples.append(capability.capitalize())
        required_samples = list(set(required_samples))
        self.create_tests_files(required_samples)

    def _substitute_test_variable_names(self):
        """
        Substitutes test variable names based on the environment for which the tests are created.
        """
        start_char = self.args.project_type[0][0].lower()
        original_string = "${wvar('"
        replace_string = "${" + start_char + "var('"
        files_to_substitute = [
            os.sep.join([self.args.location, "Tests", variables.SUPPORT_ROBOT]),
            os.sep.join([self.args.location, "Tests", "Sample", "Support_Sample.robot"])]
        if original_string != replace_string:
            self.logger.info("Substitute variable name to first project area type.")
            for file_path in files_to_substitute:
                self.replace_file_data(file_path, original_string, replace_string)

    def create_virtualenv_folder_and_chdir_to_it(self):
        """
        Creates a folder for virtual environment and cd into it.
        """
        virtual_parent_path = os.sep.join([self.args.location, "Virtualenv"])
        self.logger.info("Creating Virtual Environment folder")
        if not os.path.isdir(virtual_parent_path):
            self.create_folder(virtual_parent_path)
        self.logger.info("Change directory to %s", virtual_parent_path)
        os.chdir(virtual_parent_path)

    def create_local_virtual_environment(self):
        """
        Creates local virtual environment
        """
        check_existing_path = os.sep.join([self.args.project_name, "Scripts"])
        python_executable = "python3"
        if platform.system() == "Windows":
            check_existing_path = os.sep.join([self.args.project_name, "bin"])
            python_executable = sys.executable

        if not os.path.exists(check_existing_path):
            cmd = python_executable + " -m venv " + self.args.project_name
            self.logger.info(variables.EXECUTING_TEMPLATE, cmd)
            subprocess.call(cmd, shell=True)

    def get_python_virtualenv_path(self):
        """
        Gets the path to python in the virtual environment based on system type
        :return: Python.exe or executable path inside the virtual environment created
        """
        osname = self.dependency_handler.get_os_name()
        if self.args.no_virtual_environment:
            python_path = sys.executable
        else:
            if osname == "windows":
                python_path = '"' + os.sep.join(["Virtualenv", self.args.project_name,
                                                 "Scripts", "python"]) + '"'
            else:
                python_path = '"' + os.sep.join(["Virtualenv", self.args.project_name,
                                                 "bin", "python"]) + '"'
        return python_path

    def update_local_pip(self, python_path):
        """
        Updates local pip to latest version.
        """
        pip_update_command = python_path + " -m pip install --upgrade pip"
        self.logger.info("Updating pip")
        self.logger.info(variables.EXECUTING_TEMPLATE, pip_update_command)
        subprocess.call(pip_update_command, shell=True)

    def install_local_virtualenv_requirements(self, python_path):
        """
        Installs any virtual environment requirements
        :param python_path: Python executable path to install requirements in venv
        """
        requirements_file = os.sep.join(["dependencies", "requirements.txt"])
        pip_cmd = python_path + " -m pip install -r " + \
            '"' + requirements_file + '"'
        self.logger.info(variables.EXECUTING_TEMPLATE, pip_cmd)
        subprocess.call(pip_cmd, shell=True)

    def create_virtual_env(self):
        """
        Creates virtual environment for the project locally.
        """
        if self.args.no_virtual_environment:
            self.logger.info("No Virtual Environment is to be created. " +
                             "Ensure dependencies are pre-installed.")
            return
        self.create_virtualenv_folder_and_chdir_to_it()
        self.create_local_virtual_environment()
        self.logger.info("Change directory to %s", self.args.location)
        os.chdir(self.args.location)
        python_path = self.get_python_virtualenv_path()
        self.update_local_pip(python_path)
        self.logger.info("Installing project requirements to virtual environment")
        self.install_local_virtualenv_requirements(python_path)

    def _execute_sample_test_tidy(self):
        """
        Tidies up the code base after creation.
        """
        self.logger.info("Executing tidy feature on test space")
        os.chdir(self.args.location)
        execute_cmd = self.get_python_virtualenv_path() + \
            os.sep.join([" Execution", "driver.py"]) + " --tidy"
        if "salesforce" in self.args.project_type:
            self.logger.info("Initializing git for Cumulusci project using git init")
            subprocess.call("git init", shell=True)
            execute_cmd += " --salesforce"
        self.logger.info(variables.EXECUTING_TEMPLATE, execute_cmd)
        subprocess.call(execute_cmd, shell=True)

    def _execute_sample_test(self):
        """
        Executes sample test from the newly created project space.
        """
        self.logger.info("Executing sample helloworld test")
        self.logger.info("When Get_Start completes, and if not running in a docker image, ")
        self.logger.info("to run the sample robot framework test:")
        self.logger.info("1.  Activate the Virtual Environment in tests/Virtualenv/*  ")
        os.chdir(self.args.location)
        execute_cmd = self.get_python_virtualenv_path() + \
                      os.sep.join([" Execution", "driver.py"]) + " -i helloworld"
        if "salesforce" in self.args.project_type:
            self.logger.info("1b. Connect to a Salesforce org (see tests/Readme.md)  ")
            execute_cmd += " --salesforce -co <connected org-alias>"
        self.logger.info("2.  Execute the following command: %s", execute_cmd)
        self.logger.info(variables.EXECUTING_TEMPLATE, execute_cmd)
        return subprocess.call(execute_cmd, shell=True)

    def update_existing_project(self):
        """
        Updates libraries in existing project space.
        This does not update the python library files so the user
        has to create such libraries themselves.
        """
        self.logger.info("Enhancing project keywords starting.")
        self.add_user_libraries()
        cur_dir_path = os.path.dirname(os.path.realpath(__file__))
        robot_updater_obj = RobotUpdater()
        for library_path in self.enhance_folders:
            files = [os.path.join(library_path, f)
                     for f in os.listdir(library_path)
                     if os.path.isfile(os.path.join(library_path, f))
                     and f.endswith(".robot") and not f.startswith("__init__")]
            for filename in files:
                area, strip_filename = filename.split(os.sep)[-2:]
                updated_filename = os.path.join(cur_dir_path, "Robot_Scripts_Setup", "Tests",
                                                area, strip_filename)
                if os.path.isfile(updated_filename):
                    robot_updater_obj.check_file_for_keywords_update(
                        updated_filename, filename)
        self.logger.info("Enhancing project keywords complete.")

    def create_new_project_space(self):
        """
        Creates the projects folder structure. Main function in Builder.
        """
        self.logger.info("---------- Starting Robot Framework Project creation ----------")
        self.create_project_folder()
        self._create_dependencies_folder()
        self._add_gitignore_file()
        self._add_readme_md_file()
        self.create_execution_files()
        self.eat_integration_files()
        self.jpm_template_files()
        self.create_data_files()
        self.add_user_libraries()
        self.create_sample_tests()
        self._substitute_test_variable_names()
        self.create_virtual_env()
        self._execute_sample_test_tidy()
        status = self._execute_sample_test()
        self.logger.info("---------- Completed Robot Framework Project creation ----------")
        return status

    def update_project(self):
        """
        Creates the projects folder structure. Main function in Builder.
        """
        if self.args.enhance_existing:
            self.update_existing_project()
            return 0
        else:
            return self.create_new_project_space()


if __name__ == "__main__":
    BUILDER = Builder()
    sys.exit(BUILDER.update_project())