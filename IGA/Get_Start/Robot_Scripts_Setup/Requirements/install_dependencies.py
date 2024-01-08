"""
This file helps install the dependencies to get started with robot framework.
"""

import argparse
import os
import platform
import struct
import sys
from distutils.version import LooseVersion


class DependencyHandler:
    """
    Builds the dependencies required to work with Robot framework project.
    """
    def __init__(self, project_location):
        self.project_location = project_location
        self.args = None

    @staticmethod
    def get_os_name():
        """
        Returns OS name of the system used.
        :return: one of [linux, windows, cygwin, solaris, macosx, posix]
        """
        sys_platform = str(sys.platform).lower()
        osname = "windows"
        if "linux" in sys_platform:
            osname = "linux"
        if 'win32' in sys_platform:
            osname = "windows"
        if 'cygwin' in sys_platform:
            osname = "cygwin"
        if 'sunos' in sys_platform:
            osname = "solaris"
        if 'darwin' in sys_platform:
            osname = "macosx"
        if 'posix' in os.name.lower():
            osname = "posix"
        return osname

    @staticmethod
    def get_python_version():
        "Gets the system python version if it is '2' or '3'"
        major_python_versions = tuple(
            map(str, platform.python_version_tuple()))
        return major_python_versions[0]

    @staticmethod
    def get_bitsize():
        "Gets bit size for the machine. Returns either 32 or 64"
        return struct.calcsize('P') * 8

    @staticmethod
    def get_system_endianness():
        "Gets byteorder for the system. Either 'little' or 'big'"
        return sys.byteorder

    def parse_arguments(self, arguments=None):
        """
        Creates a parser for required parameters.
        :param arguments: Arguments from command line or passed directly to this method
        """
        parser = argparse.ArgumentParser(
            "Parser to install required dependencies")
        parser.add_argument("-s", "--selenium", help="Install selenium library",
                            action='store_true')
        parser.add_argument("-a", "--appium", help="Install appium library",
                            action='store_true')
        parser.add_argument("-sl", "--salesforce", help="Install salesforce library",
                            action='store_true')
        parser.add_argument("-rq", "--requests", help="Install requests libraries",
                            action='store_true')
        parser.add_argument("-e", "--excel", help="Install excel libraries",
                            action='store_true')
        parser.add_argument("-db", "--database", help="Install database libraries",
                            action='store_true')
        parser.add_argument("-nr", "--no_robot", help="Skip installing robot framework",
                            action='store_true')

        if arguments is None:
            arguments = sys.argv[1:]
        self.args = parser.parse_args(arguments)

    def create_wheel_directory(self):
        """
        Creates a wheel file directory in the project location
        :return: Directory holding wheel dependencies
        """
        wheel_dir = os.sep.join([self.project_location, "dependencies"])
        if not os.path.isdir(wheel_dir):
            os.makedirs(wheel_dir)
        return wheel_dir

    def _read_requirements(self, requirements_file):
        """
        Reads requirements listed in requirements file
        :param requirements_file: Path to requirements file with qualified version of requirements
        :return: List of requirements to be added
        """
        requirements = []
        with open(requirements_file, "r") as file_object:
            for line in file_object.readlines():
                if line.strip():
                    requirements.append(line.strip())
        return requirements

    def _update_requirements(self, requirements, file_path):
        """
        Reads requirements from file_path relative to curdir and adds them to requirements
        :param requirements: List of requirements to be created
        :param file_path: File path relative to current directory containing requirements
        """
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.sep.join([dir_path, file_path])
        file_requirements = self._read_requirements(file_path)
        requirements.extend(file_requirements)

    @staticmethod
    def _update_requirement_version_dict(requirements, req_version_dict):
        """
        Updates requirements based on Looseversion comparison into req_version_dict
        :param requirements: Unique list of requirements to be parsed
        :param req_version_dict: Requirement dict to be updated.
        """
        for requirement in requirements:
            if "==" in requirement:
                key, value = requirement.split("==")
            else:
                key = requirement
                value = ""
            value = value.strip()
            if key in req_version_dict:
                if req_version_dict[key] and \
                        LooseVersion(value) > LooseVersion(req_version_dict[key]):
                    req_version_dict[key] = value
            else:
                req_version_dict[key] = value

    def select_latest_requirements(self, requirements):
        """
        Parses the requirements list removing duplicate requirements and updating to latest version
        :param requirements: Current list of requirements fetched will be updated in place
        """
        requirements = list(set(requirements))
        req_version_dict = {}
        self._update_requirement_version_dict(requirements, req_version_dict)
        requirements = []
        for key, value in req_version_dict.items():
            if value:
                line = key + "==" + value
            else:
                line = key
            requirements.append(line)
        return requirements

    def get_requirement_arguments(self):
        """
        From the arguments built from parse_arguments()
        this gets the list required to be installed.
        """
        requirements = []
        if not self.args.no_robot:
            self._update_requirements(requirements, "robot_common_requirements.txt")
        if self.args.selenium:
            self._update_requirements(requirements, "web_requirements.txt")
        if self.args.appium:
            self._update_requirements(requirements, "mobile_requirements.txt")
        if self.args.requests:
            self._update_requirements(requirements, "api_requirements.txt")
        if self.args.excel:
            self._update_requirements(requirements, "excel_requirements.txt")
        if self.args.salesforce:
            self._update_requirements(requirements, "salesforce_requirements.txt")
        if self.args.database:
            self._update_requirements(requirements, "database_requirements.txt")
        requirements = self.select_latest_requirements(requirements)
        return requirements
