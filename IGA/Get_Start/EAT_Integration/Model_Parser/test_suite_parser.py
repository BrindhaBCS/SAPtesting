"""
Parses for data that reside under a testsuite in Robot Xml report
"""
import os
from Models.test_suite_model import TestSuite
from .variables import JIRA_ID, LABEL_ID
from .parse_keywords import ParseKeywords
from Support.times_support import TimeSupport


class TestSuiteParser:
    """
    Parses for data under a test-suite identified by tag suite
    """
    def __init__(self, test_tag, soup_support, parent_folder_path=""):
        """
        Initializes TestSuiteParser using a soup xml tag to identify test
        :param test_tag: bs4.Element.Tag object to identify the test parent suite to parse
        :param soup_support: Support.Soup object to support with test suite data processing
        """
        self.suite_tag = test_tag.parent
        self.soup_support = soup_support
        self.parent_folder_path = parent_folder_path
        self.time_support = TimeSupport(self.soup_support)
        self.suites = {}

    def fetch_test_suite_data(self, dependencies, data_driven, action):
        """
        Fetches test data read under the initialized suite_tag
        :param dependencies: List of python dependencies used to execute Robot Tests
        :return: Models.TestSuite element
        """
        suite_doc = self.soup_support.get_child_element_text(self.suite_tag, "doc")
        suite_doc = self.soup_support.get_xml_unescape(suite_doc)
        suite_name = self.suite_tag.get("name").strip()
        suite_name = self.soup_support.get_xml_unescape(suite_name)
        if self.suites.get(suite_doc + suite_name):
            return self.suites[suite_doc + suite_name]
        suite_details = self._get_suite_details(suite_doc)
        parse_keywords = ParseKeywords(self.suite_tag, recursive=False)
        parse_keywords.setup_variable_data()
        suite_detail_dict = parse_keywords.get_step_details(time_support=self.time_support, 
                                                        data_driven=data_driven, action=action)
        setup_variables = suite_detail_dict.get("variables")
        suite = self._get_suite(
            suite_name, suite_doc, suite_details["jira_id"], suite_details["label_id"],
            setup_variables, dependencies)
        return suite

    def _get_suite_details(self, suite_doc):
        """
        Reads through the suite tag to gather details regarding the suite
        :param suite_doc: Suite documentation from doc tag under suite
        :return: Dict of format: {"source": "", "suite_doc": "", "jira_id/qtest_id": "", "label_id": ""}
        """
        suite_source = self._get_suite_source()
        jira_id, suite_doc = self.soup_support.get_doc_extraction(JIRA_ID, suite_doc, "")
        label_id, suite_doc = self.soup_support.get_doc_extraction(LABEL_ID, suite_doc, "")
        suite_dict = {"source": suite_source,
                          "suite_doc": suite_doc,
                          "jira_id": jira_id.upper(),
                          "label_id": label_id,
                          }            
        return suite_dict

    def _get_suite_source(self):
        """
        Fetches suite source detail from suite tag
        :return: String data representing suite source
        """
        suite_source = self.suite_tag.get("source")
        suite_source = suite_source.rsplit(".", 1)[0]
        if self.parent_folder_path:
            suite_source = suite_source[len(self.parent_folder_path):]
        if suite_source[0] in [os.sep, "\\"]:
            suite_source = suite_source[1:]
        return suite_source.strip()

    def _get_suite(self, suite_path, description, jira_id, label_id,
                   suite_variables=None, dependencies=None):
        """
        Fetches an existing test suite or creates a new one if not already existing
        and returns that object.

        :param suite_path: Path of the suite folder location
        :param description: Documentation attached with the testsuite
        :param jira_id: Jira id read from suite documentation
        :param label_id: Label id read from suite documentation
        :param suite_variables: Suite setup variable information
        :param dependencies: List of python dependencies used to execute the tests
        :return: Test_Suite object created or searched using path and documenation
        """
        suite = TestSuite(suite_path=suite_path, description=description, jira_id=jira_id,
                          label_id=label_id, dependencies=dependencies,
                          suite_variables=suite_variables)
        self.suites[description + suite_path] = suite
        return suite
