"""
This module handles creation of tests and results into Jira XRay.
"""
import os
from Xray.xray_user_arguments import UserArguments
from Xray.Xray_Result_Parser import json_creator
from File_Parser import xml_robot
from Xray.Xray_Handler.eat_rest_api_handler import EatApiHandler
from Support import logger_handler


class XrayUploader:
    """
    Handles creation of XRay test and results through Robot or Json format report
    """
    def __init__(self):
        parser = UserArguments()
        self.args = parser.parse_arguments()
        if not os.path.isabs(self.args.results_file):
            self.args.results_file = os.path.abspath(self.args.results_file)
        report_file = self.args.results_file
        if self.args.CREATE_TEST_JSON_FORMAT:
            self.args.action = "Create_Test"
        if self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.args.action = "Add_Result"
        self.logger = logger_handler.setup(results_file=report_file, action=self.args.action)                                        
        self.jira = None
        self.eat_handler = None
        self.suites = []
        self.classified_dict = {}

    def process_xray_request(self):
        """
        Handles the overall flow for XRay test/result upload
        """
        if self.args.dryrun:
            self.logger.info("Starting Xray upload dryrun...")
        if not (self.args.CREATE_TEST_JSON_FORMAT or self.args.RESULT_UPLOAD_JSON_FORMAT):
            self.logger.info("Please specify parameter to create test (-ct_json) or add result (-res_json)")
        else:
            self._read_test_results()
            self.eat_handler = EatApiHandler(self.args)
            file_path = self.create_json_format()
            if self.args.CREATE_TEST_JSON_FORMAT:
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
        json_create = json_creator.JsonCreator(self.suites, self.args, self.eat_handler)
        return json_create.create_json_file()


if __name__ == "__main__":
    XRAY_UPLOADER = XrayUploader()
    XRAY_UPLOADER.process_xray_request()
