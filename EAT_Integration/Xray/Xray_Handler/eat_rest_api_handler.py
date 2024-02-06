"""
This module handles working with eat api that will automatically create, configure the test and pre-approve for the execution
"""

import os
import json
import Xray.xray_variables as variables
from Support import logger_handler
from Xray.xray_api_requests import XrayApiRequests

class EatApiHandler(object):
    """
    Handles connection and api execution to Jira using EAT API
    """
    def __init__(self, user_args):
        self.args = user_args
        if not os.path.isabs(self.args.results_file):
            self.args.results_file = os.path.abspath(self.args.results_file)
        report_file = self.args.results_file
        self.logger = logger_handler.setup(results_file=report_file,
                                                action=self.args.action)
        self.token = self._generate_token()
        if not self.token:
            self.logger.info("Authentication token for EAT API could not be obtained")
        self.update_dic = {}
        self.create_dic = {}
        self.update_tests = []

    """
    Generates token required to authenticate into EAT API
    """
    def _generate_token(self):
        self.logger.info("Getting authentication token for url: %s", self.args.eat_url)
        self.xray_api = XrayApiRequests("", "", self.args)
        self.token = ""
        url = self.args.eat_url + variables.XRAY_API_LOGIN_URL
        body_json = {
            variables.USERNAME_KEY: self.args.username,
            variables.PASSWORD_KEY: self.args.password
        }
        result = self.xray_api._request_query("POST", url, headers=variables.API_HEADERS, json=body_json)
        if result:
            self.token = json.loads(result).get('token')
        return self.token

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
                self.logger.info("Creating  %s", str(len(self.create_dic["suite"])) + " new test(s)")
                self._create_approved_test_dict(self.create_dic)
                self._call_endpoint(variables.XRAY_API_CREATE_TEST, self.create_dic)
            if len(self.update_tests) > 0:
                self.logger.info("Updating %s", str(len(self.update_tests)) + " test(s)")
                for test in self.update_tests:
                    self._generate_payload([test], self.update_dic, body_json["project"])
                    self._call_endpoint(variables.XRAY_API_UPDATE_TEST, self.update_dic)
        elif self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.logger.info("Creating EAT API test execution : %s", file_path)
            self._call_endpoint(variables.XRAY_API_CREATE_TEST_EXECUTION, body_json)
    
    def _call_endpoint(self, url_string, body):
        url = self.args.eat_url + url_string
        if self.args.dryrun:
            self.logger.info("No request call due to dryrun")
        else:
            result = self.xray_api._request_query("POST", url, self.token, json=body)
            self.logger.info("Result : %s", result)

    def _process_json_file(self, body):
        """
        Parses the json body and separates it in 2 different payloads, one for createTest and one for updateTest.
        :param body: the json retrieved from file
        """
        project = body["project"]
        search_key = 'testKey'
        test_name_key = 'testName'
        create_suites = []
        for suite in body["suite"]:
            for test in suite['tests']:
                self.logger.info("Test Name : %s", test[test_name_key])
                if not test.get(search_key):
                    self.logger.info("Following test does not exist in Jira: %s", test[test_name_key])
                    create_suites.append(suite)
                else:
                    self.logger.info("Following test does exist in Jira: %s", test[test_name_key])
                    self.update_tests.append(suite)          
        self._generate_payload(create_suites, self.create_dic, project)  

    def _generate_payload(self, array_name, dictionary_name, project):
        if len(array_name) > 0:
            dictionary_name.update({
                    "project": project,
                    "suite": array_name
                    })

    def _create_approved_test_dict(self, report_test):
        """
        Creates dictionary to process creation of new test
        :param report_test: The test read from xml/json report
        :return: dictionary to process data creation
        """
        test_dict = report_test
        if self.args.CREATE_TEST_JSON_FORMAT and self.args.stop_approval_on_test_creation:
            test_dict.update(
                {
                    "moveToCompleted": True
                })
        return test_dict

    def _read_json_file(self, file_path):
        if os.path.isfile(file_path):
            with open(file_path, "r") as file_object:
                file_data = file_object.read()
                file_data = file_data.replace('\n', '')
                return json.loads(file_data)