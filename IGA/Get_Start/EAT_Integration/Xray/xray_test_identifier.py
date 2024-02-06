"""
Classifies test into various types based on comparison with Jira issues
"""
import html
from jira.exceptions import JIRAError
from ..Support import logger_handler
import xray_variables


class TestIdentifier:
    """
    Classifies tests into various types based on Jira data
    """
    def __init__(self, suites, args=None, jira=None):
        self.logger = logger_handler.setup()
        self.suites = suites
        self.args = args
        self.jira = jira
        self.jira_issue_linked_tests_dict = {}

    def classify_tests(self):
        """
        Reads through the suite list and builds tests to be uploaded into XRay
        into various different types
        :returns dict of format: {classification: {test_from_report: jira linked test}}
        """
        classification_dict = {}
        test_dependencies = []
        for suite in self.suites:
            if not test_dependencies and suite.dependencies:
                test_dependencies = suite.dependencies
            for test in suite.tests:
                self.logger.info("Fetching linked Jira ID for the test: %s", test.name)
                story_jira_id = self._get_jira_id_for_test(test.jira_id, suite.jira_id)
                if not story_jira_id:
                    self.logger.info(
                        "Jira id not available. Upload will not continue for test: %s", test.name)
                    continue
                self.logger.info("Linked Jira ID(s) for Test are: %s", ",".join(story_jira_id))
                try:
                    test_classification, jira_test = self._lookup_test_in_jira(
                        test, story_jira_id)
                    classification_dict.setdefault(test_classification, {})
                    classification_dict[test_classification][test] = jira_test
                except JIRAError:
                    self.logger.error("Failed to classify test under Jira ID: %s," +
                                      " testname: %s", story_jira_id, test.name)
        classification_dict[xray_variables.DEPENDENCIES] = test_dependencies
        return classification_dict

    def _get_jira_id_for_test(self, test_jira_id, suite_jira_id):
        """
        Fetches jira id to be used for test identification
        :param test_jira_id: Jira id value defined inside the test
        :param suite_jira_id: Jira id value defined at suite level
        :return: jira id to be used
        """
        jira_id = test_jira_id
        if not jira_id:
            jira_id = suite_jira_id
        if not jira_id:
            jira_id = self.args.jira_project_id
        return jira_id

    def _lookup_test_in_jira(self, test, story_jira_id):
        """
        Searches for presence of test in Jira and builds the searched tests list.
        Sets up the test classification then based on this result
        :param test: Test object read from report parser
        :param story_jira_id: Jira Id used for searching test in Jira
        :return: Find if test exists in Jira and return the
                 category and test issue object
        """
        self.logger.info("Fetching linked tests to Jira Issue: %s", ",".join(story_jira_id))
        linked_tests = self.jira_issue_linked_tests_dict.get(str(story_jira_id))
        if not linked_tests:
            self.jira_issue_linked_tests_dict[str(story_jira_id)] = \
                self.jira.setup_linked_tests(story_jira_id)
            linked_tests = self.jira_issue_linked_tests_dict[str(story_jira_id)]
        test_category = xray_variables.TEST_NOT_FOUND
        jira_test = None
        for linked_test in linked_tests:
            jira_test_name = str(html.unescape(linked_test.fields.summary.strip()))
            if jira_test_name == test.name:
                test_category = xray_variables.TEST_NAME_FOUND
                jira_test = linked_test
                if self._compare_steps_same(test, linked_test):
                    test_category = xray_variables.TEST_MATCHES_EXACTLY
        return test_category, jira_test

    @staticmethod
    def _compare_steps_same(report_test, jira_test):
        """
        Compares steps are same in jira test as compared to what is being uploaded through report.
        Compares step name and expected value for equality.
        :param report_test: Test read from the report of the format XRay_Result_Parser.Models.Test
        :param jira_test: Test read from Jira
        :return: True if the test steps match exactly.
        """
        step_same = len(report_test.steps) == len(jira_test.fields.customfield_11404.steps)
        if step_same:
            jira_steps = jira_test.fields.customfield_11404.steps
            for counter, step in enumerate(report_test.steps):
                jira_test_description = getattr(jira_steps[counter].fields, "Expected Result")
                jira_test_result = getattr(jira_steps[counter].fields, "Action")
                if step.description != jira_test_description or\
                        step.expected != jira_test_result:
                    step_same = False
                    break
        return step_same
