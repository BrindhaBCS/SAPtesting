"""
This module handles working with eat api that will automatically create, configure the test and pre-approve for the execution
"""

import os
import json
from requests import RequestException
import Qtest.qtest_variables as variables
from Support import logger_handler
from Qtest.qtest_api_requests import QtestApiRequests

class QtestApiHandler(object):
    """
    Handles connection and api execution to Jira using EAT API
    """
    def __init__(self, user_args):
        self.args = user_args
        self.qtest_api = QtestApiRequests("", "", self.args)
        self.token = self.args.qtest_token
        if not os.path.isabs(self.args.results_file):
            self.args.results_file = os.path.abspath(self.args.results_file)
        report_file = self.args.results_file
        self.logger = logger_handler.setup(results_file=report_file,
                                                action=self.args.action)
        self.update_dic = []
        self.create_dic = []

    def _create_test(self, file_path=None, semaphore=None):
        """
        Creates a test/test execution in Jira based on the test object built through parsing xml/json reports.
        :param file_path: the path to generated json
        :param semaphore: For parallel execution acquire a semaphore before running
        :return: True if test created successfully
        """
        body_json = self._read_json_file(file_path)
        if self.args.CREATE_TEST_JSON_FORMAT:
            self.logger.info("Creating/updating EAT API test: %s", self.args.eat_url)
            self._process_json_file(body_json)
            if len(self.create_dic) > 0:
                self.logger.info("Creating  %s", str(len(self.create_dic)) + " new test(s)")
                self._call_endpoint(variables.QTEST_API_CREATE_TEST, self.create_dic)
            if len(self.update_dic) > 0:
                self.logger.info("Updating %s", str(len(self.update_dic)) + " test(s) ")
                self._call_endpoint(variables.QTEST_API_UPDATE_TEST, self.update_dic)
        if self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.logger.info("Creating EAT API test execution :")
            self._call_endpoint(variables.QTEST_API_CREATE_TEST_EXECUTION, body_json)
    
    def _call_endpoint(self, url_string, body):
        url = self.args.eat_url + url_string
        for test_payload in body:
            if self.args.dryrun:
                self.logger.info("No request call due to dryrun")
            else:
                result = self.qtest_api._request_query("POST", url, self.token, json=test_payload)
                self.logger.info("Result : %s", result)

    def _process_json_file(self, body):
        """
        Parses the json body and separates it in 2 different payloads, one for createTest and one for updateTest.
        :param body: the json retrieved from file
        """
        search_key = 'testId'
        test_name_key = 'testName'
        for test in body:
            self.logger.info("Test Name : %s", test[test_name_key])
            if not test.get(search_key):
                self.logger.info("Following test does not exist in qTest: %s", test[test_name_key])
                self.create_dic.append(test)
            else:
                self.logger.info("Following test exists in qTest: %s", test[test_name_key])
                self.update_dic.append(test)

    def _read_json_file(self, file_path):
        with open(file_path, "r") as file_object:
            file_data = file_object.read()
            file_data = file_data.replace('\n', '')
            return json.loads(file_data)