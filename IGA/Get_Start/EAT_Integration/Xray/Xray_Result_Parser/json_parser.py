"""
Provides a json processing starting instance. This supports in creating report
for any new framework to build structures for processing to create report for
XRay.
"""
import json
from datetime import datetime
from Support.date_and_time_support import DateTimeSupport
from Models.attachment import Attachment
from Models.test_model import Test
from Models.step_model import Step
from Models.test_suite_model import TestSuite
from Models import model_support


class JsonParser:
    """
    Starts execution of Robot Output Result which is the default Output.xml file
    generated through Robot Framework results
    """
    def __init__(self, report_path):
        """
        Initialized by passing the Json report path to be processed
        :param report_path: Absolute path to Json report.
        """
        self.report_path = report_path
        self.suites = []
        self.date_time_support = DateTimeSupport()

    def parse_results(self):
        """
        Reads through data passed through report_path and builds suites information based on it
        """
        json_data = self._read_json_file()
        for suite in json_data["Suites"]:
            suite_description = model_support.convert_list_to_line_separated(
                suite.get("Description", ""))
            suite_jira_id = model_support.convert_to_list(suite.get("Suite_Jira_ID", ""))
            suite_label_id = model_support.convert_to_list(suite.get("Suite_Label_ID", ""))
            suite_tag_info = model_support.convert_to_list(suite.get("Suite_Tag_Info", ""))
            suite_tag_info = model_support.convert_list_to_string(suite_tag_info)
            variables = model_support.read_variable_string(suite.get("Variables", ""))
            dependencies = model_support.get_comma_separated_variable_list(
                suite.get("Dependencies", []))
            suite_object = TestSuite(
                description=suite_description,
                tests=[],
                jira_id=suite_jira_id,
                label_id=suite_label_id,
                dependencies=dependencies,
                suite_variables=variables)
            tests = suite.get("Tests", [])
            suite_object.tests = self._read_tests_information(tests)
            self.suites.append(suite_object)

    def _read_attachments(self, attachment_list):
        """
        Reads attachment objects from attachment list
        :param attachment_list: List of attachments.
        :return: Attachment objects list
        """
        attachment_objects = []
        for attachment_dict in attachment_list:
            attachment_time = self.date_time_support.get_datetime_for_json(
                attachment_dict["creation_time"])
            attachment_objects.append(Attachment(attachment_dict["path"],
                                                 attachment_time))
        return attachment_objects

    def _read_tests_information(self, tests):
        """
        Reads tests information from the json file
        :param tests: Tests section inside the suites section in json data
        :return: Tests list read inside the suite
        """
        suite_tests = []
        for test in tests:
            test_status = test.get("Status", "Failed")
            test_description = model_support.convert_list_to_line_separated(
                test.get("Description", ""))
            attachments = self._read_attachments(test.get("Attachments", []))
            start_time = self.date_time_support.get_datetime_for_json(
                test.get("Start_Time", datetime.now()))
            end_time = self.date_time_support.get_datetime_for_json(
                test.get("End_Time", datetime.now()))
            test_jira_id = model_support.convert_to_list(test.get("Story_Jira_Ids", ""))
            test_label_id = model_support.convert_to_list(test.get("Labels", ""))
            test_tags = model_support.convert_to_list(test.get("Tags", ""))
            test_tags = model_support.convert_list_to_string(test_tags)
            variables = model_support.read_variable_string(test.get("Variables", ""))
            data_driven = model_support.check_data_driven_from_string(
                test.get("Data_Driven", False))
            test_obj = Test(name=test["Name"],
                            steps=[],
                            result=test_status,
                            attachment=attachments,
                            doc=test_description,
                            start_time=start_time,
                            end_time=end_time,
                            story_jira_id=test_jira_id,
                            label_id=test_label_id,
                            data_driven_test=data_driven,
                            variables=variables,
                            test_tags=test_tags)
            test_steps = test.get("Steps", [])
            steps, test_obj.result = self._read_steps_information(test_steps)
            test_obj.steps = steps
            suite_tests.append(test_obj)
        return suite_tests

    def _read_steps_information(self, steps):
        """
        Reads steps information from the json file
        :param steps: Steps section inside the test section in json data
        :return: Steps list and overall test status
        """
        overall_status = "Passed"
        test_steps = []
        for step in steps:
            attachments = self._read_attachments(step.get("Attachments", []))
            start_time = self.date_time_support.get_datetime_for_json(
                step.get("Start_Time", datetime.now()))
            end_time = self.date_time_support.get_datetime_for_json(
                step.get("End_Time", datetime.now()))
            step_expected = model_support.convert_list_to_line_separated(
                step.get("Expected", ""))
            step_description = model_support.convert_list_to_line_separated(
                step.get("Description", ""))
            step_actual = model_support.convert_list_to_line_separated(step.get("Actual", ""))
            step_variables = step.get("Variables", None)
            step_status = step.get("Status", "Failed")
            step_execution_counter = step.get("Execution_Counter", 1)
            test_steps.append(Step(description=step_description,
                                   expected=step_expected,
                                   actual=step_actual,
                                   status=step_status,
                                   attachment=attachments,
                                   start_time=start_time,
                                   end_time=end_time,
                                   variables=step_variables,
                                   execution_counter=step_execution_counter))
            if (step["Status"] == "Failed") and (overall_status == "Passed"):
                overall_status = "Failed"
        return test_steps, overall_status

    def _read_json_file(self):
        """
        Reads json file data from self.report_path
        :return: json data dict read from the file
        """
        with open(self.report_path, "r") as file_object:
            file_data = file_object.read()
        file_data = file_data.replace('\n', '')
        return json.loads(file_data)
