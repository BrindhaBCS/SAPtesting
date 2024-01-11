"""
Handles XRay api requests.
"""
import base64
import json
import os
import mimetypes
import ntpath
import sys
import requests
import Xray.xray_variables as variables
from Support import logger_handler
from Support.date_and_time_support import DateTimeSupport
from Models.attachment import Attachment


class XrayApiRequests:
    """
    Handles XRay API request processing. Any REST API calls are made through this.
    """
    def __init__(self, test, jira_test, args):
        """
        Initializes the class with test variables containing information to build and process
        test data payload
        :param test: Test to be uploaded for result
        :param jira_test: Jira object of test being uploaded
        :param args: User defined arguments
        """
        self.logger = logger_handler.setup()
        self.test = test
        self.jira_test = jira_test
        self.args = args
        self.datetime_support = DateTimeSupport(self.args)

    def build_test_execution_payload(self, test_execution_issue):
        """
        Builds dictionary for test execution creation payload.
        This is as read from url:
        https://confluence.xpand-it.com/display/public/XRAY/Import+Execution+Results+
            -+REST#ImportExecutionResults-REST-XrayJSONresults
        Format is:
        {"testExecutionKey": "DEMO-1206",
        "info" :
        {
            "summary" : "Execution of automated tests for release v1.3",
            "description" : "This execution is automatically created when
                            importing execution results from an external source",
            "version" : "v1.3",
            "user" : "admin",
            "revision" : "1.0.42134",
            "startDate" : "2014-08-30T11:47:35+01:00",
            "finishDate" : "2014-08-30T11:53:00+01:00",
            "testPlanKey" : "DEMO-100",
            "testEnvironments": ["iOS", "Android"]
        },
        "tests": []}
        :param test_execution_issue: Test Execution Issue for finding existing
            information on test execution in Jira
        :return: dict for test execution creation and test execution issue object
        """
        if self.args.xray_test_env:
            test_environments = self.args.xray_test_env
        else:
            test_environments = self.args.test_server
        if test_environments and isinstance(test_environments, str):
            test_environments = [test_environments]
        summary, description = self._get_test_execution_details(test_execution_issue)
        test_execution_dict = {
            "info": {
                "summary": summary,
                "description": description,
                "user": self.args.username,
                "testEnvironments": test_environments,
                }
        }
        if self.args.xray_testexecution_id:
            test_execution_dict["testExecutionKey"] = self.args.xray_testexecution_id
        test_execution_dict["tests"] = self._build_tests_data_dict()
        test_execution_dict["info"]["startDate"] = test_execution_dict["tests"][0]["start"]
        test_execution_dict["info"]["finishDate"] = test_execution_dict["tests"][-1]["finish"]
        return test_execution_dict, test_execution_issue

    def _get_test_execution_details(self, test_execution_issue):
        """
        Fetches summary and description details from an existing test execution issue
        :param test_execution_issue: Jira issue of type test execution
        :return: summary and description for the test execution
        """
        summary = variables.SUMMARY
        updated_string = "Updated: "
        description = variables.EXECUTION_DESCRIPTION + \
            self.datetime_support.get_time_format_string()
        if test_execution_issue:
            summary = test_execution_issue.fields.summary
            description = test_execution_issue.fields.description
            if description and updated_string in description and description.endswith(
                    self.datetime_support.get_timezone_local):
                description = description.rsplit(updated_string, 1)[0] + \
                              updated_string + self.datetime_support.get_time_format_string()
        return summary, description

    def _build_tests_data_dict(self):
        """
        Updates test_list with data read from test details. Format for list element dict is:
        {
            "testKey" : "DEMO-6",
            "start" : "2014-08-30T11:47:35+01:00",
            "finish" : "2014-08-30T11:50:56+01:00",
            "comment" : "Datetime when test was executed",
            "status" : "PASS"
            "evidences" : [
                {
                    "data": "iVBOR(...base64 file enconding)",
                    "filename": "image21.jpg",
                    "contentType": "image/jpeg"
                }
            ],
            "examples" : [
                "PASS",
                "PASS",
                "PASS",
                "PASS",
                "FAIL"
            ],
            "steps": []
        }
        :param test_list: List to append dict structures of tests to
        :return list of tests json dict format
        """
        time_string = self.datetime_support.get_time_string_for_action(
            self.test.start_time, self.test.end_time)
        test_dict = {
            "testKey": self.jira_test.key,
            "start": self.datetime_support.get_api_datetime(self.test.start_time),
            "finish": self.datetime_support.get_api_datetime(self.test.end_time),
            "comment": time_string + self.test.doc,
            "status": self.test.result[:4].upper(),
        }
        if self.test.attachment:
            test_dict["evidences"] = self._read_evidences_to_json(self.test.attachment)
        if self.test.steps:
            self._get_steps_result_data(self.test.steps, test_dict)
        return [test_dict]

    def _get_steps_result_data(self, steps, test_dict):
        """
        Steps data read for uploading results into XRay. Steps dict format:
        {
                    "status": "PASS",
                    "actualResult": "Coment on Test Step Result 1",
                    "evidences" : [
                        {
                            "data": "iVBO(...base64 file enconding)",
                            "filename": "image22.jpg",
                            "contentType": "image/jpeg"
                        }
                    ]
                }
            ]
        }

        :param steps: steps data read inside report of xml/json data
        :param test_dict: Test data dictionary to be updated with step and example values
        """
        step_list = []
        update_examples = False

        for step in steps:
            time_string = self.datetime_support.get_time_string_for_action(
                step.start_time, step.end_time)
            step_status = step.status[:4].upper()
            step_dict = {
                "status": step_status,
                "actualResult": time_string + step.actual,
            }
            if step.attachment:
                step_dict["evidences"] = self._read_evidences_to_json(step.attachment)
            if step.execution_counter > 1:
                update_examples = True
            step_list.append(step_dict)

        if update_examples:
            self._update_test_examples(test_dict, steps)
        test_dict["steps"] = step_list

    @staticmethod
    def _update_test_examples(test_dict, steps):
        """
        Updates test dict with examples information
        :param test_dict: Test data dict to be updated with examples information
                for Data Driven test
        :param steps: Steps under a test
        """
        # Get execution statuses
        execution_status_dict = {}
        counter = 1
        for step in steps:
            if counter not in execution_status_dict:
                execution_status_dict[counter] = "PASS"
            if step.execution_counter == counter:
                if step.status.upper()[:4] == "FAIL":
                    execution_status_dict[counter] = "FAIL"
            elif step.execution_counter > counter:
                counter = step.execution_counter

        # Update examples based on execution status dict
        test_dict.setdefault("examples", [])
        for counter in execution_status_dict:
            test_dict["examples"].append(execution_status_dict[counter])

    def _read_evidences_to_json(self, attachments):
        """
        Reads json format of evidences to be attached to XRay results
        :param attachments: List of attachments to process
        :return: List of dicts of format to be attached to Json data payload
        """
        attachment_data_list = []
        for attachment in attachments:
            path = attachment
            if isinstance(attachment, Attachment):
                path = attachment.attachment_path
            encoded_data_dict = self._get_base64_encoded_data(path)
            attachment_data_list.append(encoded_data_dict)
        return attachment_data_list

    def _get_base64_encoded_data(self, file_path):
        """
        Generates base64 encoded data to be attached to the test report.
        :param file_path: The file path to be encoded
        :return: base64_data, file_name, content_type
        """
        base64_data = file_name = content_type = ""
        if isinstance(file_path, str):
            if not os.path.isfile(file_path):
                parent_path = ntpath.dirname(self.args.results_file)
                file_path = os.sep.join([parent_path, file_path])
        else:
            file_path = file_path.attachment_path

        if os.path.isfile(file_path):
            with open(file_path, "rb") as attach_file:
                b64data = base64.b64encode(attach_file.read())
            if sys.version_info[0] == 3:
                base64_data = str(b64data)[2:-1]
            content_type = mimetypes.guess_type(file_path)[0]
            file_name = ntpath.basename(file_path)
        encoded_data_dict = {
            "data": base64_data,
            "filename": file_name,
            "contentType": content_type
        }
        return encoded_data_dict

    def upload_results_to_xray(self, xray_json):
        """
        Uploads test results into XRay using xray json payload
        :param xray_json: json data to be used to upload results into Xray
        :return: True if the upload results was successful
        """
        query_result = None
        if not xray_json:
            return query_result
        if not self.args.dryrun:
            url = self.args.jira_url + variables.XRAY_EXECUTION_IMPORT_API
            query_result = self._request_query(
                "POST", url, headers=variables.API_HEADERS, json=xray_json)
            if query_result:
                data_uploaded = json.loads(str(query_result))
                query_result = data_uploaded["testExecIssue"]["key"]
        return query_result

    def _request_query(self, request_type, query, token=None, **kwargs):
        """
        Executes a REST API call based on type, query and request arguments
        :param request_type: Type of request e.g. POST or GET
        :param query: The request url to access
        :param token: Token required for authentication
        :param kwargs: query argument data to be passed as payload
        :return: False if the query operation failed or the text of successful execution
        """
        auth = (self.args.username, self.args.password)
        request_object = None
        if request_type == "POST":
            if token:
                headers = variables.API_HEADERS
                headers.update({"Authorization" : "Bearer " + token})
                request_object = requests.post(query, headers=headers, **kwargs)
            else:    
                request_object = requests.post(query, auth=auth, **kwargs)
        elif request_type == "GET":
            request_object = requests.get(query, auth=auth, **kwargs)
        result = False
        if request_object and request_object.status_code == 200:
            result = request_object.text
        else:
            self.logger.info(request_object.status_code)
            self.logger.info(request_object.text)
            self.logger.info(request_object.reason)
        return result

    @staticmethod
    def update_test_execution_gxp_req_details(test_execution_object, dependencies):
        """
        Checks on the current execution description and if it does not have latest
        message on different requirements than GxP then it updates it.
        Scenario 1: Test execution description contains the difference string and latest
            execution still has differences. In this scenario update the difference.
        Scenario 2: Test execution description contains the difference string and latest
            execution has no difference from GxP. In this add message that no longer any
            diff is present.
        Scenario 3: Test execution description does not contain the difference string and latest
            execution has no difference from GxP. In this add message that no difference exists
        Scenario 4: Test execution description does not contain the difference string and latest
            execution has difference from GxP. In this add difference string and list of
            different requirements to description
        :param test_execution_object: test execution jira object
        :param dependencies: List of dependencies which are different
                than GxP qualified dependencies
        """
        test_execution_description = test_execution_object.fields.description
        start_of_documentation = "\nRequirements different from GxP are: "
        no_difference_string = " with the latest update there " + \
                               "is no difference in gxp dependencies and project"

        if dependencies:
            diff_requirements = ",".join(dependencies)
            # Scenario 1
            if start_of_documentation in test_execution_description:
                test_execution_description = test_execution_description.split(
                    start_of_documentation, 1)[0]
                test_execution_description += diff_requirements
            else:
                # Scenario 4
                test_execution_description += start_of_documentation + diff_requirements
        elif start_of_documentation in test_execution_description:
            # Scenario 2
            test_execution_description = test_execution_description + "\n" + \
                                         no_difference_string
        elif start_of_documentation not in test_execution_description:
            # Scenario 3
            test_execution_description += "\n" + no_difference_string

        test_execution_object.update(description=test_execution_description)
