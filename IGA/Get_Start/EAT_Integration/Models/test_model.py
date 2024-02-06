"""
Defines structure for Individual test read from Robot Report
"""
from . import model_support


class Test:
    """
    Individual Test structure to be built from parsing the results file
    """
    def __init__(self, **kwargs):
        self.name = kwargs.get("name", "")
        self.steps = kwargs.get("steps", [])
        self.result = kwargs.get("result", "")
        self.attachment = model_support.convert_to_list(kwargs.get("attachment"))
        self.doc = kwargs.get("doc", "")
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
        self.jira_id = model_support.convert_to_list(kwargs.get("story_jira_id", ""))
        self.label_id = model_support.convert_to_list(kwargs.get("label_id", "Automation"))
        self.template_keyword = kwargs.get("template_keyword", "")
        self.folder = kwargs.get("folder", "")
        self.data_driven_test = kwargs.get("data_driven_test", False)
        self.variables = kwargs.get("variables")
        self.extra_variables_dict = kwargs.get("extra_variables_dict")
        self.test_tags = kwargs.get("test_tags")
        self.test_os = kwargs.get("test_os", "")
