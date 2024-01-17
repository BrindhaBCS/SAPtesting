"""
Creates Json template file from data read from Robot Framework test report.
"""
import json
import os, sys
from Support import logger_handler
from Support.date_and_time_support import DateTimeSupport
from . import parser_variables as variables
from Qtest.qtest_api_requests import QtestApiRequests


class JsonCreator:
    """
    Creates json file from data read from robot results
    """
    def __init__(self, suites, args):
        self.suites = suites
        self.args = args
        self.report_path = self.args.json_output_file
        self.json_data_list = []
        self.date_time_support = DateTimeSupport(self.args)
        self.logger = logger_handler.setup()
        self.qtest_api = QtestApiRequests("", "", self.args)
        self.datetime_support = DateTimeSupport(self.args)

    def _update_dict(self, update_dict, field, value,
                     variable=False, date_type=False):
        """
        Updates field into a data dictionary.
        :param update_dict: Dictionary to update
        :param field: Dictionary key
        :param value: Value to be updated
        :param variable: Check if value is of type variable
        :param date_type: Check if value is data type
        """
        if date_type:
            value = self.date_time_support.get_datetime_representation_json(value)
        elif variable:
            top_level_variables = self._read_variable_dict(value)
            keyword_level_variables = self._read_variable_dict(value.get(
                "Keyword_Name_Variables", {}))
            argument_level_variables = self._read_variable_dict(value.get(
                "Arguments", {}))
            top_level_variables.extend(keyword_level_variables)
            top_level_variables.extend(argument_level_variables)
            value = ",".join(top_level_variables)
        if value:
            update_dict[field] = value
        else:
            self.logger.info("Value must be supplied for required field : %s", field)
            import sys
            sys.exit()

    def _payload_required_field(self, update_dict, field, value):
        """
        Updates field into a data dictionary.
        :param update_dict: Dictionary to update
        :param field: Dictionary key
        :param value: Value to be updated
        """
        if value:
            update_dict[field] = value
        else:
            update_dict[field] = " "

    @staticmethod
    def _read_variable_dict(variable_dict):
        """
        Variable dict which may contain keys for USER and ROBOT to be read in the
        format key:value,key2:value2.. etc.
        :param variable_dict: Dict which may contain variable values for ROBOT and USER types
        :return: string of value read from the dict
        """
        variable_value = []
        if isinstance(variable_dict, dict):
            for key in variable_dict.get("USER", {}):
                variable_value.append(key + ":" + variable_dict["USER"][key])
            for key in variable_dict.get("ROBOT", {}):
                variable_value.append(key + ":" + variable_dict["ROBOT"][key])
        return variable_value

    def create_json_file(self):
        """
        Creates Json format file from data read from robot report Output.xml
        :return: file path created with json data
        """
        if self.args.CREATE_TEST_JSON_FORMAT:
            self.args.action = "Create_Test"
            self._create_test_json_dict()
        elif self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.args.action = "Add_Result"
            self._add_result_json_dict()
        json_log_data = json.dumps(self.json_data_list)
        if not os.path.isabs(self.report_path):
            directory = os.path.dirname(self.args.results_file)
            self.report_path = os.sep.join([directory, self.report_path])
        with open(self.report_path, 'w') as json_file:
            json_file.write(str(json_log_data))
        self.logger.info("Created Json file from Robot Data at: %s" % self.report_path)
        self.logger.info("Json file data: \n%s" % json_log_data)
        return self.report_path

    def _check_and_update_dict(self, value, update_dict, field_name):
        """
        Updates field name into update dict based on if value is available
        :param value: Check to see if the value is available
        :param update_dict: Dict to update field value to
        :param field_name: Name of the field to update in update_dict
        """
        if value:
            self._update_dict(update_dict, field_name, value)

    def _get_first_test_datadriven(self):
        if self.args.data_driven and self.args.CREATE_TEST_JSON_FORMAT:
            self.suites = [self.suites[0]]
            if not self.suites[0].tests:
                self.suites[0].tests = []
            else:
                self.suites[0].tests = [self.suites[0].tests[0]]

    def _create_test_json_dict(self):
        """
        Processes data read from robot framework output to json format data
        """
        self._get_first_test_datadriven()
        for suite in self.suites:
            qtest_id = self.args.qtest_project_id
            if not suite.tests:
                suite.tests = []
            for test in suite.tests:
                test_dict = {}
                self._update_dict(test_dict, variables.PROJECT_FIELD, qtest_id)
                self._check_and_update_dict(self.args.qtest_folder_id, test_dict, variables.FOLDER_FIELD)
                self._process_for_test_key(test_dict, qtest_id, self.args.qtest_folder_id, test.name)
                add_step_no = False
                if variables.TEST_ACTION in test_dict and test_dict[variables.TEST_ACTION] == "update": 
                    add_step_no = True
                test_detail_dict = self._get_create_tests_json_list(test, add_step_no)
                test_dict.update(test_detail_dict)
                self._update_dict(test_dict, variables.TEST_TYPE, "Automation")
                self._update_dict(test_dict, variables.MOVE_TO_COMPLETE, "true")
                if self.args.stop_approval_on_test_creation:
                    self._update_dict(test_dict, variables.MOVE_TO_COMPLETE, "false")
                self._update_dict(test_dict, variables.AUTOMATION_CONTENT, suite.suite_path + "/" + test.name)
                test_additional = self._get_additional_fields()
                self._update_dict(test_dict, variables.TEST_ADDITIONAL_FIELDS, test_additional)
                self.json_data_list.append(test_dict)

    def _get_additional_fields(self):
        additional_fields = [{ "fieldName" : "Priority", "fieldValue" : self.args.qtest_overall_priority }]
        obsoleted_field = { "fieldName" : "Obsoleted", "fieldValue" : self.args.qtest_obsoleted }
        if self.args.include_qtest_obsoleted:
            additional_fields.append(obsoleted_field)
        return additional_fields

    def _process_for_test_key(self, test_dict, project, folder, test_name):
        """
        Adds test key to create/update dictionary if the test has already been created in jira
        :param body: the create/update test dictionary 
        :param project: the project key
        """
        if self.args.CREATE_TEST_JSON_FORMAT:
            search_key = variables.UPDATE_TEST_ID
        elif self.args.RESULT_UPLOAD_JSON_FORMAT:
            search_key = variables.TEST_ID
        self.logger.info("Test Name : %s", test_name)
        if not test_dict.get(search_key):
            test_id = self._get_test_id(project, folder, test_name)
            if test_id == "Error":
                self.logger.info("Issue with API check for existing test, unable to proceed")
                sys.exit()
            elif "Test is in " in str(test_id):
                self.logger.info("%s", test_id)
                sys.exit()
            elif test_id == "No test":
                self.logger.info("Following test does not exist in qTest: %s", test_name)
                if self.args.RESULT_UPLOAD_JSON_FORMAT:
                    self.logger.info("Unable to proceed with test run creation")
                    sys.exit()
            else:
                self.logger.info("Test id exists in qTest : %s", test_id)
                test_dict[search_key] = str(test_id)
                if self.args.CREATE_TEST_JSON_FORMAT:
                    self._update_dict(test_dict, variables.TEST_ACTION, "update")
                

    def _get_test_os(self, tests):
        for test in tests:
            return test.test_os
    
    def _get_qtest_key(self, documentation):
        """
        Fetches jira project id based on documentation.
        :param documentation: Documentation from suite
        :return: Jira project id code string
        """
        if self.args.qtest_project_id:
            return self.args.qtest_project_id
        else:
            return self._get_key(documentation)   

    def _get_key(self, documentation):
        """
        Fetches qtest project based on documentation from tests or suites.
        :param documentation: Documentation from test or suite
        :return: project id
        """
        project_id = ""
        key_string = "qtest-id:"
        if key_string in documentation.lower():
            project_id  = documentation.lower().split(key_string, 1)[1]
        else:
            self.logger.info("qTest project ID not specified in command or documentation")
        return project_id.strip()

    def _update_results_dict(self, test_dict, test):
        """
        Updates test_dict with key-values for test results
        """
        if self.args.qtest_run_id != "":
            self._update_dict(test_dict, variables.TEST_RUN_ID, self.args.qtest_run_id)
            self._update_dict(test_dict, variables.TEST_RUN_ACTION, "update")
        else:
            self._update_dict(test_dict, variables.TEST_RUN_ACTION, "create")
        self._update_dict(test_dict, variables.TEST_RUN_EXECUTION_LOG, "Execution Log - " + test.name)
        self._update_dict(test_dict, variables.TEST_START, self.datetime_support.get_api_datetime(test.start_time))
        self._update_dict(test_dict, variables.TEST_FINISH, self.datetime_support.get_api_datetime(test.end_time))
        if (test.result.__contains__("Pass")):
            self._update_dict(test_dict, variables.TEST_STATUS, variables.SE_STATUS_DEFAULT)
        else:
            self._update_dict(test_dict, variables.TEST_STATUS, variables.SE_STATUS_FAIL)
        if self.args.qtest_run_note:
            self._update_dict(test_dict, variables.TEST_EXECUTION_NOTE, self.args.qtest_run_note) 
        else:
            self._update_dict(test_dict, variables.TEST_EXECUTION_NOTE, "Test run for " + test.name) 
        return test_dict

    def _update_create_test_dict(self, test_dict, test):
        """
        Updates test_dict with key-values for test creation
        """
        self._update_dict(test_dict, variables.TEST_NAME, test.name)
        self._update_dict(test_dict, variables.TEST_ASSIGNEE, self.args.qtest_assignee)
        if not test.doc:
            test.doc = test.name
        self._update_dict(test_dict, variables.TEST_DESCRIPTION, test.doc)
        self._update_dict(test_dict, variables.TEST_LEVEL, self.args.test_level)
        self._payload_required_field(test_dict, variables.PREREQUISITES, self.args.qtest_prerequisites)
        return test_dict

    def _get_create_tests_json_list(self, test, add_step_no):
        """
        Reads tests information in a list of dicts for json generation.
        Supports generation of json for create test workflow
        :param tests: Test objects under a suite
        :return: list of dictionary containing test information.
        """
        test_dict = {}
        if self.args.RESULT_UPLOAD_JSON_FORMAT:
            test_dict = self._update_results_dict(test_dict, test)
            test_dict[variables.STEPS_RESULTS_SECTION] = self._get_create_tests_steps_list(test.steps, add_step_no=True)
        if self.args.CREATE_TEST_JSON_FORMAT:
            test_dict = self._update_create_test_dict(test_dict, test)
            test_dict[variables.STEPS_SECTION] = self._get_create_tests_steps_list(test.steps, add_step_no)
        return test_dict

    def _get_list_name_dictionary(self, values_list):
        result = []
        for value in values_list:
            result.append(self._get_name_dictionary(value))
        return result
    
    def _get_name_dictionary(self, value):
        result = {}
        if value:
            result[variables.NAME] = value
        return result   

    def _get_create_tests_steps_list(self, steps, add_step_no):
        """
        Reads steps information in a list of dicts for json generation.
        Supports generation of json for create test workflow
        :param steps: Step objects under a test
        :return: list of dictionary containing steps information.
        """
        steps_list = []
        for step_no, step in enumerate(steps):
            step_dict = {}
            if add_step_no:
                self._update_dict(step_dict, variables.STEP_ORDER, step_no + 1)
            if self.args.RESULT_UPLOAD_JSON_FORMAT:
                if (step.status.__contains__("Pass")):
                    self._update_dict(step_dict, variables.STEP_STATUS, variables.SE_STATUS_DEFAULT)
                else:
                    self._update_dict(step_dict, variables.STEP_STATUS, variables.SE_STATUS_FAIL)
                self._update_dict(step_dict, variables.STEP_EXPECTED_RESULT, step.description)
                self._update_dict(step_dict, variables.STEP_DESCRIPTION, step.expected)
                self._update_dict(step_dict, variables.STEP_ACTUAL_RESULT, step.actual)
                step_dict[variables.STEP_ATTACHMENT] = self._get_attachments_json_list(step.attachment)
            elif self.args.CREATE_TEST_JSON_FORMAT:
                self._update_dict(step_dict, variables.STEP_EXPECTED_RESULT, step.description)
                self._update_dict(step_dict, variables.STEP_DESCRIPTION, step.expected)
                step_dict[variables.STEP_ATTACHMENT] = []
            steps_list.append(step_dict)
        return steps_list

    def _add_result_json_dict(self):
        """
        Processes data read from robot framework output to json format data
        Supports creation of test result.
        """
        for suite in self.suites:
            qtest_id = self.args.qtest_project_id
            for test in suite.tests:
                test_dict = {}
                self._update_dict(test_dict, variables.ADD_PDF_REPORT, variables.ADD_PDF_REPORT_DEFAULT)
                self._update_dict(test_dict, variables.PROJECT_FIELD, qtest_id)
                self._update_dict(test_dict, variables.TEST_NAME, test.name)
                if self.args.qtest_parent_type != "":
                    self._update_dict(test_dict, variables.TEST_RUN_PARENT, self.args.qtest_parent_id)
                if self.args.qtest_parent_id != "":
                    self._update_dict(test_dict, variables.TEST_RUN_PARENT_TYPE, self.args.qtest_parent_type)
                self._update_dict(test_dict, variables.AUTOMATION_CONTENT, suite.suite_path + "/" + test.name)
                test_additional = self._get_additional_fields()
                self._update_dict(test_dict, variables.TEST_ADDITIONAL_FIELDS, test_additional)
                test_detail_dict = self._get_create_tests_json_list(test, add_step_no=True)
                test_dict.update(test_detail_dict)
                self._process_for_test_key(test_dict, qtest_id, self.args.qtest_folder_id, test.name)
                self._process_add_result_payload(test_dict, qtest_id, test.name)
                self.json_data_list.append(test_dict)

    def _process_add_result_payload(self, test_dict, project_id, test_name):
        """
        Parses the json body and alteres the payload. Based on the test name and qtest id, retrieves the existing test ids.
        If there are any, it prepares the payload for test execution update, otherwise for test execution creation. 
        :param body: the json retrieved from file
        """
        search_key = 'testRunId'
        self.logger.info("Test Name : %s", test_name)
        if not self.args.qtest_run_id:
            test_id = self._get_test_run_id(project_id, test_name)
            if test_id not in ["Error", "No test run"]:
                self.logger.info("Test run exists in qtest : %s", test_id) 
                test_dict[search_key] = test_id
            else:
                self.logger.info("Test run not found in qtest")
        else:
            test_dict[search_key] = self.args.qtest_run_id
        if not test_dict.get(search_key):
            self.logger.info("No matching test run...new test run will be created")

    def _get_test_id(self, project, folder, name):
        """
        Makes a query to qTest to get the testIDs inside the specified project module
        based on the test name/title.
        :param project: the project code
        :param name: the test name to search for
        :return: testid if any found in open state, or empty
        """
        if folder:
            url = self.args.qtest_url + variables.QTEST_SEARCH_ISSUE + project + \
                "/test-cases?parentId=" + folder + "&page=1&size=20000&expandProps=false&expandSteps=false"
        else:
            url = self.args.qtest_url + variables.QTEST_SEARCH_ISSUE + project + \
                "/test-cases?page=1&size=20000&expandProps=false&expandSteps=false"
        token = self.args.qtest_token
        result, status_code = self.qtest_api._request_query_qtest("GET", url, token)
        test_check = "No test"
        if int(status_code) > 200:
            test_check = "Error"
        if result:
            result_json = json.loads(result)
            open_test_list, completed_test_list = self._get_open_and_completed_tests(result_json, name)
            test_check = self._get_test_check_result(test_check, open_test_list, completed_test_list)
        return test_check

    def _get_open_and_completed_tests(self, result_json, name):
        completed_test_list = []
        open_test_list = []
        for test_group in result_json:
            if test_group["name"] == name:
                if test_group["version"].endswith('.0'):
                    completed_test_list.append(test_group["id"])
                else:
                    open_test_list.append(test_group["id"])
        return open_test_list, completed_test_list

    def _get_test_check_result(self, test_check, open_test_list, completed_test_list):
        """
        For test creation, check that test is not in Completed state if it exists
        For test execution, check that test is not in Open state
        """
        if self.args.CREATE_TEST_JSON_FORMAT:
            if len(open_test_list) > 0:
                test_check = open_test_list[0]
            elif len(completed_test_list) > 0:
                test_check = "Test is in completed state - unable to proceed"
        elif self.args.RESULT_UPLOAD_JSON_FORMAT:
            if len(completed_test_list) > 0:
                test_check = completed_test_list[0]
            elif len(open_test_list) > 0:
                test_check = "Test is in open state - unable to proceed"
        return test_check

    def _get_test_run_id(self, project, name):
        """
        Makes a query to qTest to get the testRunIDs based on the test name/title.
        :param project: the project code
        :param name: the test name to search for
        :return: testRunid if any found or empty
        """
        url = self.args.qtest_url + variables.QTEST_SEARCH_ISSUE + project + \
                                                    "/test-runs?page=1&size=20000&expandProps=false"
        token = self.args.qtest_token
        result, status_code = self.qtest_api._request_query_qtest("GET", url, token)
        if int(status_code) > 200:
            return "Error"
        if result:
            result_json = json.loads(result)
            for test_group in result_json:
                if test_group is dict and test_group['name'] == name:
                    return test_group['id']
        return "No test run"

    def _get_attachments_json_list(self, attachments):
        """
        Converts json dictionary to a list of dicts for json generation
        :param attachments: attachments under a test step
        :return: list of dictionaries containing attachments information.
        """
        return list(map(self._get_attachments_json_dict, attachments))

    def _get_attachments_json_dict(self, attachment):
        """
        Parses the attachment data
        :param attachment: Attachment data to be parsed
        :return: a json dictionary containing attachment information
        """
        attachment_dict = {}
        if attachment.data:
            attachment_dict[variables.STEP_ATTACHMENT_DATA] = attachment.data.decode()
            attachment_dict[variables.STEP_ATTACHMENT_FILENAME] = attachment.filename
            attachment_dict[variables.STEP_ATTACHMENT_CONTENT_TYPE] = attachment.content_type
        return attachment_dict