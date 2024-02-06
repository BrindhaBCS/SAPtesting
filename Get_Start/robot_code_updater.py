"""
Parses for keywords through the robot files looking for updates
"""
import os
import pprint
import subprocess
import sys
import logger_handler
import variables


class RobotUpdater:
    """
    Parses Robot files, compares and updates missing information
    """

    def __init__(self):
        self.keyword_string = variables.KEYWORDS_STRING
        self.test_string = "*** test cases ***"
        self.logger = logger_handler.setup('Keywords_Updater')

    @staticmethod
    def sort_dict(dict_object):
        "Sorts a dictionary object"
        sorted_dict_object = {}
        for key in sorted(dict_object.keys()):
            sorted_dict_object[key] = dict_object[key]
        return sorted_dict_object

    @staticmethod
    def read_file_data(filepath):
        "Reads data from file as separate lines."
        data = ""
        if os.path.isfile(filepath):
            with open(filepath, "r") as fileobject:
                data = fileobject.readlines()
        return data

    @staticmethod
    def extract_section_data(datalines, keyword_string):
        """
        Checks presence of keyword string in the file and returns
        two separate sections.
        """
        key_data = setup_data = []
        indexkeyword = [datalines.index(word) for word in datalines
                        if word.lower().strip() == keyword_string]
        if indexkeyword:
            key_data = datalines[indexkeyword[0] + 1:]
            setup_data = datalines[:indexkeyword[0] + 1]
        return key_data, setup_data

    @staticmethod
    def _append_data_lines_on_keyword(start, readend, datalines, keyword_name, datalist):
        """
        Reads data from data line and if keyword is found then set and return
        keywordname
        :param start: Line number where to start reading
        :param readend: Line number until when to read
        :param datalines: Data lines
        :param keyword_name: Name of the keyword
        :param datalist: List where data is to be appended
        :return: name of the keyword
        """
        for i in range(start, readend):
            data = datalines[i].strip()
            if not keyword_name:
                keyword_name = data
                continue
            if data:
                datalist.append(data)
        return keyword_name

    def extract_data_under_string(
            self, datalines, keyword_string=variables.KEYWORDS_STRING):
        """
        Extracts data under a string in a file.
        Separating by start of new line from the start of the line.
        """
        datalines, _ = RobotUpdater.extract_section_data(
            datalines, keyword_string)

        keywords = {}
        start = 0
        for end, line in enumerate(datalines):
            if ((line[0] != " " and line[0] != "\t" and line.strip()) or\
                    end == len(datalines) - 1) and end > start:
                keyword_name = ""
                datalist = []
                readend = end
                if readend == len(datalines) - 1:
                    readend += 1
                keyword_name = self._append_data_lines_on_keyword(
                    start, readend, datalines, keyword_name, datalist)
                keywords[keyword_name] = datalist
                start = end
        keywords = RobotUpdater.sort_dict(keywords)
        return keywords

    def get_keywords(self, filepath):
        "Fetches keywords as dictionary data."
        # Read data from file
        datalines = self.read_file_data(filepath)
        return self.extract_data_under_string(datalines, self.keyword_string)

    def get_testcases(self, filepath):
        "Fetches testcases as dictionary data."
        # Read data from file
        datalines = self.read_file_data(filepath)
        return self.extract_data_under_string(datalines, self.test_string)

    def tidy_file(self, filepath):
        "Tidies up code base "
        command = '"' + sys.executable + '" -m robot.tidy --inplace ' +\
            '"' + filepath + '"'
        self.logger.info("Executing: %s", command)
        subprocess.call(command, shell=True)

    def update_keywords_in_file(self, filepath, keywords):
        """
        Updates keywords in the filepath.
        This is going backwards into the file after checking the diff.
        """
        self.logger.info("Updating file with new keywords: %s", filepath)
        data = ""
        newline = """
"""
        for key in sorted(keywords.keys()):
            data += key + newline
            for keystep in keywords[key]:
                data += "\t" + keystep + newline
            data += newline

        filedata = self.read_file_data(filepath)
        _, start_data = self.extract_section_data(
            filedata, variables.KEYWORDS_STRING)
        data = "".join(start_data).strip() + newline + data

        with open(filepath, "w") as fileobject:
            fileobject.write(data)

        self.tidy_file(filepath)

    @staticmethod
    def _get_diff_keywords_to_update(gsg_keywords, project_keywords):
        """
        Gets the difference that needs to be updated to project keywords.
        Finds what is added or different in gsg_keywords and overrides them to project keywords
        :param gsg_keywords: keywords that are read from equivalent gsg robot resource file
        :param project_keywords: Keywords that are read from equivalent project robot resource file
        :return: boolean check to verify if the update is required or not
        """
        update = False
        for gsg_keyword, gsg_value in gsg_keywords.items():
            if gsg_keyword not in project_keywords or \
                    gsg_value != project_keywords[gsg_keyword]:
                project_keywords[gsg_keyword] = gsg_value
                update = True
        return update

    def check_file_for_keywords_update(self, gsg_file, project_file):
        """
        Compares keywords in gsg_file and if they are missing in project_file.
        They are then added to project_file. Expecting both to be Robot Resource files
        """
        gsg_file_keywords = self.get_keywords(gsg_file)
        project_file_keywords = self.get_keywords(project_file)
        update_required = self._get_diff_keywords_to_update(
            gsg_file_keywords, project_file_keywords)

        if update_required:
            self.logger.info("Updating from the latest keywords in %s", gsg_file)
            self.update_keywords_in_file(project_file, project_file_keywords)

    @staticmethod
    def print_extracted_data(data):
        """
        Prints the data in a pretty print format
        :param data: data object to be pretty printed
        """
        prettyprinter = pprint.PrettyPrinter(indent=4)
        prettyprinter.pprint(data)

    def print_keywords(self, file_path):
        """
        Prints the extracted keywords
        :param file_path: Keywords to be printed from the file
        """
        keywords = self.get_keywords(file_path)
        self.print_extracted_data(keywords)

    def print_tests(self, file_path):
        """
        Prints the extracted test cases
        :param file_path: Prints the extracted test cases from file
        """
        test_cases = self.get_testcases(file_path)
        self.print_extracted_data(test_cases)
