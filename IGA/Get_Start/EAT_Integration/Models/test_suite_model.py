"""
Test Suite structure details
"""
from . import model_support


class TestSuite:
    """
    Test Suite structure to be built for passing to Test Management tool
    """

    def __init__(self, **kwargs):
        """
        Constructs Test Suite. Expects following parameters to be passed
        :param suite_path: Path for the suite used for ALM artefact creation
        :param description: Documentation for the suite
        :param tests: Tests linked to the test suite
        :param jira_id: Jira ID for the test suite
        :param label_id: Labels for the test suite
        :param dependencies:
        :param suite_variables: Suite setup keyword variables list
        """
        self.suite_path = kwargs.get("suite_path", "")
        self.description = kwargs.get("description", "")
        self.tests = kwargs.get("tests", [])
        self.dependencies = kwargs.get("dependencies", None)
        self.jira_id = model_support.convert_to_list(kwargs.get("jira_id", ""))
        self.label_id = model_support.convert_to_list(kwargs.get("label_id", "Automation"))
        self.suite_variables = kwargs.get("suite_variables", None)
