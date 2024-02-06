"""
This module handles creation of tests and results into qTest.
"""
import os
from Qtest.qtest_user_arguments import UserArguments
from Qtest.Qtest_Result_Parser.Parser import json_creator
from File_Parser import xml_robot
from Qtest.Qtest_Handler.eat_rest_api_handler import QtestApiHandler
from Support import logger_handler


class QtestUploader:
    """
    Handles creation of qTest test and results through Robot or Json format report
    """
    def __init__(self):
        parser = UserArguments()
        self.args = parser.parse_arguments()
        report_file = self.args.results_file
        self.logger = logger_handler.setup(results_file=report_file)
        if not os.path.isabs(self.args.results_file):
            self.args.results_file = os.path.abspath(self.args.results_file)
        if self.args.CREATE_TEST_JSON_FORMAT:
            self.args.action = "Create_Test"
        if self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.args.action = "Add_Result"                                        
        self.eat_handler = None
        self.suites = []
        self.classified_dict = {}

    def process_qtest_request(self):
        """
        Handles the overall flow for qTest test/result upload
        """
        if self.args.dryrun:
            self.logger.info("Starting qTest upload dryrun...")
        if not (self.args.CREATE_TEST_JSON_FORMAT or self.args.RESULT_UPLOAD_JSON_FORMAT):
            self.logger.info("Please specify parameter to create test (-ct_json) or add result (-res_json)")
        else:
            self._read_test_results()
            self.eat_handler = QtestApiHandler(self.args)
            file_path = self.create_json_format()
            self.eat_handler._create_test(file_path)

    def _read_test_results(self):
        """
        Based on type of test report being uploaded read the data from the parsing functionality
        Updates data read into self.suites
        """
        parser = xml_robot.XmlRobot(self.args.results_file, self.args.data_driven, self.args.template, self.args.action)
        self.logger.info("Parsing Results file for test information")
        parser.parse_results()
        self.suites = parser.suites

    def create_json_format(self):
        """
        Creates json format after data is read in class structure of self.suites
        """
        json_create = json_creator.JsonCreator(self.suites, self.args)
        return json_create.create_json_file()    

if __name__ == "__main__":
    QTEST_UPLOADER = QtestUploader()
    QTEST_UPLOADER.process_qtest_request()
