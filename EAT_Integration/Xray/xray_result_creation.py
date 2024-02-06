"""
Handles creation of Test Result in XRay.
"""
import xray_variables
from ..Support import logger_handler


class ResultCreation:
    """
    Creates test in XRay.
    """
    def __init__(self, test_classification, args, jira):
        """
        Initializes ResultCreation with classified tests
        :param test_classification: dict of format:
            {classification: {test_from_report: jira linked test}}
        :param args: User defined arguments to support test creation
        :param jira: Object of class Handler.jira_support.JiraHandler
        """
        self.logger = logger_handler.setup()
        self.test_classification = test_classification
        self.args = args
        self.jira = jira
        self.test_execution_issue = None
        self.test_execution_dates = None

    def process_test_result_creation(self):
        """
        Process creation of test results based on classification
        """
        self.logger.info("Adding Results:")
        self._ignore_tests_not_in_xray()
        reviewed_tests = self._ignore_tests_not_reviewed()
        self._add_results_for_reviewed_tests(reviewed_tests)

    def _ignore_tests_not_in_xray(self):
        """
        Skips creation of results for tests not found in XRay.
        Logs the information for debugging.
        """
        tests_not_in_xray = self.test_classification.get(xray_variables.TEST_NOT_FOUND)
        if tests_not_in_xray:
            self.logger.info("Following tests are not added to XRay currently "
                             "and the results will not be added for them.")
            self._log_tests_summary(tests_not_in_xray)

    def _ignore_tests_not_reviewed(self):
        """
        Skips creation of results for tests which are not in Completed status.
        Logs the information for debugging.
        :returns: List of test which are in completed state and for which result
                    can be added.
        """
        test_differing_steps = self.test_classification.get(xray_variables.TEST_NAME_FOUND, {})
        all_tests = self.test_classification.get(xray_variables.TEST_MATCHES_EXACTLY, {})
        all_tests.update(test_differing_steps)
        not_reviewed = []
        reviewed = []
        for test in all_tests:
            if all_tests[test].fields.status.name != xray_variables.TEST_COMPLETED_STATUS:
                not_reviewed.append(test)
            else:
                reviewed.append(test)
        if not_reviewed:
            self.logger.info("Following tests are not in status Completed in XRay currently "
                             "and the results will not be added for them.")
            for test_counter, test in enumerate(not_reviewed):
                self.logger.info("%d: %s with Jira-ID: %s", test_counter + 1,
                                 test.name, all_tests[test].key)
        return reviewed

    def _log_tests_summary(self, tests):
        """
        Logs the tests in a list to the
        :param tests: Test list of report xml/json type for which the information is to be logged
        """
        for test_counter, test in enumerate(tests):
            self.logger.info("%d: %s", test_counter + 1, test.name)

    def _setup_test_execution(self):
        """
        Creates test execution jira issue or fetches from existing one.
        """
        if not self.test_execution_issue:
            if not self.args.xray_testexecution_id and not self.args.no_jira_upload:
                self.test_execution_issue = self.jira.create_test_execution()
                if self.test_execution_issue:
                    self.args.xray_testexecution_id = self.test_execution_issue.key
            elif self.args.xray_testexecution_id and not self.test_execution_issue:
                self.test_execution_issue = self.jira.jira.issue(
                    self.args.xray_testexecution_id)

    def _upload_reviewed_tests(self, reviewed_tests, classified_tests):
        """
        Adds results for tests which are in completed state and are ready for
        results upload
        :param reviewed_tests: Tests ready for result upload
        :param classified_tests: Tests after classification
        :return True if the tests are uploaded successfully
        """
        self.test_execution_dates = {xray_variables.TEST_EXECUTION_FIRST_START: None,
                                     xray_variables.TEST_EXECUTION_LAST_END: None}
        uploaded = [True]
        for counter, test in enumerate(reviewed_tests):
            if self.args.dryrun:
                self.logger.info("%d. '%s' Result will not be added into Jira '%s'"
                                 "for test id '%s'."
                                 "This is a Dry Run. NO changes effected in jira.",
                                 counter+1, test.name, self.args.xray_testexecution_id,
                                 classified_tests[test].key)
            else:
                self._setup_test_execution()
                self.jira.add_result(test, classified_tests[test],
                                     self.test_execution_issue, counter+1,
                                     uploaded=uploaded)
        return uploaded[0]

    def _update_test_execution_details(self, uploaded, classified_tests):
        """
        Updates test execution details after update of test execution results
        :param uploaded: Boolean to check if tests were uploaded successfully
        :param classified_tests: Tests after classification
        """
        if self.args.xray_testexecution_id and uploaded:
            if not self.test_execution_issue:
                self.test_execution_issue = self.jira.jira.issue(self.args.xray_testexecution_id)
            self.jira.update_dependencies_to_test_execution(
                self.test_execution_issue, classified_tests["dependencies"])
            self.jira.update_issue_with_dict(self.test_execution_issue,
                                             self.args.tests_execution_fields)
            self.logger.info("Test Execution ID for the Result: %s",
                             self.args.xray_testexecution_id)

    def _add_results_for_reviewed_tests(self, reviewed_tests):
        """
        Adds results for tests which are in completed state and are ready for
        results upload
        :param reviewed_tests: Tests ready for result upload
        """
        if reviewed_tests:
            self.logger.info("Adding Results for %d Tests.", len(reviewed_tests))
        classified_tests = self._get_updated_tests_from_classification(reviewed_tests)
        uploaded = self._upload_reviewed_tests(reviewed_tests, classified_tests)
        self._update_test_execution_details(uploaded, classified_tests)

    def _get_updated_tests_from_classification(self, tests):
        """
        Looks for test under the self.test_classification and puts them into a dict
        :param tests: tests to be processed
        :return: Dict of classified tests put directly as key value pair in a dict
        """
        test_dict = {xray_variables.DEPENDENCIES: self.test_classification[xray_variables.DEPENDENCIES]}
        for test in tests:
            for classification in self.test_classification:
                if test in self.test_classification[classification].keys():
                    test_dict[test] = self.test_classification[classification][test]
                    break
        return test_dict
