"""
Creates Json template file from data read from Robot Framework test report.
"""
from datetime import datetime, timezone
import json
import os
from Support import logger_handler
from Support.date_and_time_support import DateTimeSupport
from . import parser_variables as variables
from Xray.xray_api_requests import XrayApiRequests
import shutil


class JsonCreator:
    """
    Creates json file from data read from robot results
    """
    def __init__(self, suites, args, eat_handler):
        self.suites = suites
        self.args = args
        self.report_path = self.args.json_output_file
        self.json_data_dict = {}
        self.date_time_support = DateTimeSupport(self.args)
        self.logger = logger_handler.setup()
        self.xray_api = XrayApiRequests("", "", self.args)
        self.datetime_support = DateTimeSupport(self.args)
        self.eat_handler = eat_handler

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
            json_log_data = json.dumps(self.json_data_dict, indent=2)
            if not os.path.isabs(self.report_path):
                directory = os.path.dirname(self.args.results_file)
                self.report_path = os.sep.join([directory, self.report_path])
            with open(self.report_path, 'w') as json_file:
                json_file.write(json_log_data)
            self.logger.info("Created Json file from Robot Data at: %s" % self.report_path)
            self.logger.info("Json file data: \n%s" % json_log_data)
        elif self.args.RESULT_UPLOAD_JSON_FORMAT:
            self.args.action = "Add_Result"
            self._add_result_json_dict()
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

    def _create_test_json_dict(self):
        """
        Processes data read from robot framework output to json format data
        """
        if self.suites:
            self.json_data_dict[variables.SUITE_FIELD] = []
        if self.args.data_driven and self.args.CREATE_TEST_JSON_FORMAT:
            self.suites = [self.suites[0]]
        for suite in self.suites:
            suite_dict = {}
            self.json_data_dict[variables.PROJECT_FIELD] = self._get_jira_key(suite.description)
            self._update_dict(suite_dict, variables.JIRA_ID_FIELD, suite.jira_id)
            self._update_dict(suite_dict, variables.TEST_TYPE, variables.AUTOMATION_TEST_TYPE)
            self._update_dict(suite_dict, variables.TEST_LABELS, suite.label_id)
            self._check_and_update_dict(self.args.json_overall_test_comment,
                                        suite_dict, variables.TEST_COMMENT)
            self._check_and_update_dict(self.args.json_overall_test_environment,
                                        suite_dict, variables.TEST_ENVIRONMENT_INFO)
            self._check_and_update_dict(self.args.json_overall_test_set,
                                        suite_dict, variables.TEST_SET_FOR_TESTS)
            self._check_and_update_dict(self.args.json_overall_test_plan,
                                        suite_dict, variables.TEST_PLAN_FOR_TESTS)
            self._update_dict(suite_dict, variables.SE_OS, self._get_test_os(suite.suite_variables["metadata"]))
            if not suite.tests:
                suite_dict[variables.TESTS_SECTION] = []
            elif self.args.data_driven and self.args.CREATE_TEST_JSON_FORMAT:
                suite_dict[variables.TESTS_SECTION] = self._get_create_tests_json_list([suite.tests[0]])
            else:
                suite_dict[variables.TESTS_SECTION] = self._get_create_tests_json_list(suite.tests)
            self._process_for_test_key(suite_dict, self.json_data_dict[variables.PROJECT_FIELD])
            self.json_data_dict[variables.SUITE_FIELD].append(suite_dict)

    def _process_for_test_key(self, body, project):
        """
        Adds test key to create/update dictionary if the test has already been created in jira
        :param body: the create/update test dictionary 
        :param project: the project key
        """
        jira_ids = body["jiraIds"]
        search_key = 'testKey'
        test_name_key = 'testName'
        for test in body['tests']:
            self.logger.info("Test Name : %s", test[test_name_key])
            if not test.get(search_key):
                test_id = self._get_test_id(jira_ids, project, test[test_name_key])
                if test_id:
                    self.logger.info("Test id already exists in Jira : %s", test_id) 
                    test[search_key] = test_id
                else:
                    self.logger.info("Following test does not exist in Jira: %s", test[test_name_key])

    def _get_test_os(self, metadata):
        import platform
        test_os = platform.platform()
        if 'platform' in list(metadata.keys()) and metadata['platform']: 
            test_os = str(metadata["platform"]).strip()
        return test_os
    
    def _get_jira_key(self, documentation):
        """
        Fetches jira project id based on documentation.
        :param documentation: Documentation from suite
        :return: Jira project id code string
        """
        if self.args.jira_project_id:
            return self.args.jira_project_id
        else:
            return self._get_key(documentation)   

    def _get_key(self, documentation):
        """
        Fetches jira project or test key based on documentation from tests or suites.
        :param documentation: Documentation from test or suite
        :param project: Whether the required id is project key or test key
        :return: key string
        """
        key_string = "jira-id:"
        search_string = documentation.lower().split(key_string, 1)[1]
        if "-" in search_string:
            return search_string.split("-", 1)[0].strip().upper() 
        else:
            return ""

    def _get_full_key(self, documentation):
        """
        Fetches jira id key based on documentation from suites.
        :param documentation: Documentation from test or suite
        :param project: Whether the required id is project key or test key
        :return: key string
        """
        key_string = "jira-id:"
        if key_string in documentation.lower():
            jira_id = documentation.lower().split(key_string, 1)[1].strip()
            if len(jira_id.split(' ')) > 1:
                jira_id = jira_id.split(' ')[0]
            if jira_id.endswith('.'):
                jira_id = jira_id[0:-1]
            return [jira_id.upper()]
        else:
            return []

    def _update_results_dict(self, test_dict, test):
        """
        Updates test_dict with key-values for test results
        """
        self._update_dict(test_dict, variables.TESTS_NAME, test.name)
        self._update_dict(test_dict, variables.TEST_TYPE, self.args.test_type)
        self._update_dict(test_dict, variables.TEST_START, self.datetime_support.get_api_datetime(test.start_time))
        self._update_dict(test_dict, variables.TEST_FINISH, self.datetime_support.get_api_datetime(test.end_time))
        if test.template_keyword:
            self._update_dict(test_dict, variables.TEST_COMM, test.template_keyword)
        else:
            self._update_dict(test_dict, variables.TEST_COMM, variables.SE_COMMENT_DEFAULT)
        if (test.result.__contains__("Pass")):
            self._update_dict(test_dict, variables.TEST_STATUS, variables.SE_STATUS_DEFAULT)
        else:
            self._update_dict(test_dict, variables.TEST_STATUS, variables.SE_STATUS_FAIL)    
        self._update_dict(test_dict, variables.TEST_DEFECTS, [])
        self._update_dict(test_dict, variables.TEST_EXAMPLES, [])
        return test_dict

    def _update_create_test_dict(self, test_dict, test):
        """
        Updates test_dict with key-values for test creation
        """
        self._update_dict(test_dict, variables.TESTS_NAME, test.name)
        if not test.doc and test.template_keyword:
            test.doc = test.name
        self._check_and_update_dict(test.doc, test_dict, variables.TESTS_DOCUMENTATION)
        test_labels = self.args.json_test_labels
        if test_labels and isinstance(test_labels, str):
            test_labels = test_labels.split()
        if self.args.json_test_labels:
            self._update_dict(test_dict, variables.TEST_LABELS, test_labels)
        else:    
            self._check_and_update_dict(test.label_id, test_dict, variables.TEST_LABELS)    
        priority = self.args.json_overall_priority or variables.AUTOMATION_TEST_PRIORITY
        self._update_dict(test_dict, variables.TEST_PRIORITY, self._get_name_dictionary(priority))
        if self.args.json_overall_affect_versions:
            test_dict[variables.TEST_AFFECTS_VERSION] = self._get_list_name_dictionary(self.args.json_overall_affect_versions)
        if self.args.json_overall_fixed_versions:
            test_dict[variables.TEST_FIX_VERSION] = self._get_list_name_dictionary(self.args.json_overall_fixed_versions)
        if self.args.json_overall_test_components:
            test_dict[variables.TEST_COMPONENTS] = self._get_list_name_dictionary(self.args.json_overall_test_components)
        self._update_dict(test_dict, variables.TEST_ASSIGNEE, 
                        self._get_name_dictionary(self.args.json_overall_test_assignee))
        self._update_dict(test_dict, variables.TEST_REPORTER, 
                        self._get_name_dictionary(self.args.json_overall_test_reporter))
        self._update_dict(test_dict, variables.TEST_CATEGORY,
                        self._get_name_dictionary(self.args.json_overall_test_category))                             
        self._update_dict(test_dict, variables.TEST_APPROVAL_CATEGORY,
                        self._get_name_dictionary(self.args.json_test_approval_category))
        return test_dict

    def _get_create_tests_json_list(self, tests):
        """
        Reads tests information in a list of dicts for json generation.
        Supports generation of json for create test workflow
        :param tests: Test objects under a suite
        :return: list of dictionary containing test information.
        """
        tests_list = []
        for test in tests:
            test_dict = {}
            if self.args.RESULT_UPLOAD_JSON_FORMAT:
                test_dict = self._update_results_dict(test_dict, test)
            if self.args.CREATE_TEST_JSON_FORMAT:
                test_dict = self._update_create_test_dict(test_dict, test)
            test_dict[variables.STEPS_SECTION] = self._get_create_tests_steps_list(test.steps)
            tests_list.append(test_dict)
        return tests_list

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
    
    def _get_create_tests_steps_list(self, steps):
        """
        Reads steps information in a list of dicts for json generation.
        Supports generation of json for create test workflow
        :param steps: Step objects under a test
        :return: list of dictionary containing steps information.
        """
        steps_list = []
        for step_number, step in enumerate(steps):
            step_dict = {}
            if self.args.RESULT_UPLOAD_JSON_FORMAT:
                if (step.status.__contains__("Pass")):
                    self._update_dict(step_dict, variables.STEPS_STATUS, variables.SE_STATUS_DEFAULT)
                else:
                    self._update_dict(step_dict, variables.STEPS_STATUS, variables.SE_STATUS_FAIL)
                self._update_dict(step_dict, variables.STEPS_COMMENT, variables.STEPS_COMMENT_DEFAULT)
                self._update_dict(step_dict, variables.STEPS_START, self.datetime_support.get_api_datetime(step.start_time))
                self._update_dict(step_dict, variables.STEPS_FINISH, self.datetime_support.get_api_datetime(step.end_time))
                self._update_dict(step_dict, variables.STEPS_ACTUAL_RESULT, step.actual)
                step_dict[variables.STEPS_EVIDENCES] = self._get_attachments_json_list(step.attachment)
            if self.args.CREATE_TEST_JSON_FORMAT:    
                self._update_dict(step_dict, variables.STEPS_NUMBER, str(step_number+1))
                self._update_dict(step_dict, variables.STEPS_DESCRIPTION, step.expected)
                self._update_dict(step_dict, variables.STEPS_EXPECTED, step.description)
                self._update_dict(step_dict, variables.STEPS_VARIABLES, step.variables, variable=True)
                step_dict[variables.STEP_ATTACHMENT] = []
            steps_list.append(step_dict)
        return steps_list

    def _get_add_results_info_dict(self, suite):
        """
        Returns info dictionary component of payload based on suite values and user arguments
        """
        info_dict = {}
        self._update_dict(info_dict, variables.SE_SUMMARY, variables.SE_SUMMARY_DEFAULT)
        self._update_dict(info_dict, variables.SE_DESCRIPTION, variables.SE_DESCRIPTION_DEFAULT)
        #self._check_and_update_dict(self.args.json_overall_fixed_versions, info_dict, variables.SE_VERSION)
        self._check_and_update_dict(self.args.username, info_dict, variables.SE_USER)
        self._check_and_update_dict(self.args.json_overall_test_assignee, info_dict, variables.SE_USER)
        if self.args.data_driven:
            self._update_dict(info_dict, variables.SE_REVISION, datetime.now(timezone.utc).strftime("%Y-%m-%d/%H:%M"))
        self._update_dict(info_dict, variables.SE_START_DATE, datetime.now(timezone.utc).isoformat().split('.')[0] + 'Z')
        self._update_dict(info_dict, variables.SE_FINISH_DATE, datetime.now(timezone.utc).isoformat().split('.')[0] + 'Z')
        self._update_dict(info_dict, variables.SE_PROJECT_KEY_FIELD, self._get_jira_key(suite.description))
        test_environments = self.args.xray_test_env
        if test_environments and isinstance(test_environments, str):
            test_environments = [test_environments]
        if self.args.xray_test_env:
           self._update_dict(info_dict, variables.SE_TEST_ENVIRONMENT, test_environments)
        elif suite.suite_variables["metadata"]["test_environment"]:
           self._update_dict(info_dict, variables.SE_TEST_ENVIRONMENT, [str(suite.suite_variables["metadata"]["test_environment"]).strip()])
        else:    
            self._update_dict(info_dict, variables.SE_TEST_ENVIRONMENT, variables.SE_TEST_ENVIRONMENT_DEFAULT)
        if self.args.json_overall_test_components:
            self._update_dict(info_dict, variables.TEST_EXECUTION_COMPONENTS, self.args.json_overall_test_components)
        if self.args.json_overall_affect_versions:
            self._update_dict(info_dict, variables.TEST_EXECUTION_AFFECTS_VERSION, self.args.json_overall_affect_versions)
        if self.args.json_overall_fixed_versions:
            self._update_dict(info_dict, variables.TEST_EXECUTION_FIX_VERSION, self.args.json_overall_fixed_versions)
        self._update_dict(info_dict, variables.TEST_EXECUTION_CATEGORY, self.args.json_overall_test_category)
        self._update_dict(info_dict, variables.TEST_APPROVAL_CATEGORY, self.args.json_test_approval_category)
        test_labels = self.args.json_test_labels
        if test_labels and isinstance(test_labels, str):
            test_labels = test_labels.split()
        if self.args.json_test_labels:
            self._update_dict(info_dict, variables.TEST_EXECUTION_LABELS, test_labels)
        self._update_dict(info_dict, variables.SE_BROWSER_NAME, str(suite.suite_variables["metadata"]["browser"]["browser_name"]).strip())
        self._update_dict(info_dict, variables.SE_BROWSER_VERSION, str(suite.suite_variables["metadata"]["browser"]["browser_version"]).strip())
        self._update_dict(info_dict, variables.SE_BROWSER_DRIVER_VERSION, str(suite.suite_variables["metadata"]["browser"]["browser_driver_version"]).strip())
        self._update_dict(info_dict, variables.SE_OS, self._get_test_os(suite.suite_variables["metadata"]))
        self._update_dict(info_dict, variables.SE_PLATFORM, self._get_test_os(suite.suite_variables["metadata"]))
        return info_dict

    def _add_result_json_dict(self):
        """
        Processes data read from robot framework output to json format data
        Supports creation of test result.
        """
        if self.suites:
            directory = os.path.dirname(self.args.results_file)
            tmp_dir = os.sep.join([directory, 'json_tmp'])
            if os.path.exists(tmp_dir):
                shutil.rmtree(tmp_dir)
            os.mkdir(tmp_dir)
            filename, file_extension = os.path.splitext(self.report_path)
            self._update_dict(self.json_data_dict, variables.ADD_PDF_REPORT, variables.ADD_PDF_REPORT_DEFAULT)
        for suite_count, suite in enumerate(self.suites):
            for test_count, test in enumerate(suite.tests):
                self.json_data_dict[variables.SUITE_FIELD] = []
                suite_info_dict = {variables.SE_INFO: self._get_add_results_info_dict(suite)}
                new_file = os.path.join(tmp_dir, filename + '_' + str(suite_count) + '_' + str(test_count) + file_extension)
                suite_info_dict[variables.TESTS_SECTION] = self._get_create_tests_json_list([test])
                self._process_add_result_payload(suite_info_dict, suite.jira_id)
                self.logger.info("Processing test: %s" % test.name)
                self.json_data_dict[variables.SUITE_FIELD].append(suite_info_dict)
                json_log_data = json.dumps(self.json_data_dict, indent=2)
                with open(new_file, 'w') as json_file:
                    json_file.write(json_log_data)
                self.logger.info("Updated Json file from Robot Data at: %s" % new_file)
                self.eat_handler._create_test(new_file)

    def _process_add_result_payload(self, body, jira_ids):
        """
        Parses the json body and alteres the payload. Based on the test name and jira id, retrieves the existing test ids.
        If there are any, it prepares the payload for test execution update, otherwise for test execution creation. 
        :param body: the json retrieved from file
        """
        project = body["info"]["projectKey"]
        search_key = 'testKey'
        test_name_key = 'testName'
        for test in body['tests']:
            self.logger.info("Test Name : %s", test[test_name_key])
            if not test.get(search_key):
                test_id = self._get_test_id(jira_ids, project, test[test_name_key])
                if test_id:
                    self.logger.info("Test id already exists in Jira : %s", test_id) 
                    test[search_key] = test_id
            test.pop(test_name_key, None)
            if self.args.xray_testexecution_id and not self.args.data_driven:
                body["info"].update({
                    "testExecutionKey": self.args.xray_testexecution_id
                })

    def _get_issues_testid(self, name, result_json):
        """
        Get test id from returned issue link in api response json
        """
        try:
            for issue_link in result_json['issues'][0]['fields']['issuelinks']:
                if (issue_link["type"]["inward"] == "tested by") and 'inwardIssue' in issue_link:
                    self.logger.info("Comparing test name with result from Jira : %s", issue_link['inwardIssue']['fields']['summary'])
                    if issue_link['inwardIssue']['fields']['summary'] == name: 
                        test_id = issue_link['inwardIssue']['key']
                        self.logger.info("Test ID found : %s", test_id)
                        return test_id
        except KeyError:
            self.logger.info("No test id found with the expected link to the issue (tested by)")
        return ""

    def _get_test_id(self, jira_ids, project, name):
        """
        Makes a query to Jira to get the testIDs based on the test name/title.
        :param jira_ids: the jira id of the stories
        :param project: the project code
        :param name: the test name to search for
        :return: testid if any found or empty
        """
        for id in jira_ids:
            url = self.args.jira_url + variables.JIRA_SEARCH_ISSUE + "jql=project=" + project + " AND issue=" + id + "&fields=summary,issuelinks,issuetype"
            result = self.xray_api._request_query("GET", url)
            # self.logger.info("Result: %s", result)
            if result:
                result_json = json.loads(result)
                if result_json['issues']:
                    test_id = self._get_issues_testid(name, result_json)
                    return test_id
        return ""

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
            attachment_dict[variables.STEPS_ATTACHMENT_DATA] = attachment.data.decode()
            attachment_dict[variables.STEPS_ATTACHMENT_FILENAME] = attachment.filename
            attachment_dict[variables.STEPS_ATTACHMENT_CONTENT_TYPE] = attachment.content_type
        return attachment_dict