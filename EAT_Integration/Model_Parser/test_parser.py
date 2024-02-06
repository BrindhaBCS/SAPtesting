"""
Parses for data that reside under a test in Robot Xml report
"""
import ntpath
import platform
from Support.times_support import TimeSupport
from Support.images_support import Images
from Models.test_model import Test
from .variables import JIRA_ID, LABEL_ID
from .step_parser import StepParser


class TestParser:
    """
    Parses for data under a test identified by tag test
    """
    def __init__(self, test_tag, soup_support, report_path, extra_variables):
        """
        Initializes TestParser using a soup xml tag to identify test
        :param test_tag: bs4.Element.Tag object to identify the test to parse
        :param soup_support: Support.Soup object to support with test data processing
        """
        self.test_tag = test_tag
        self.soup_support = soup_support
        self.report_path = report_path
        self.extra_variables = extra_variables

    def fetch_test_data(self, suite_object=None, metadata=None, data_driven=False, action=""):
        """
        Fetches test data read under the initialized test_tag
        :param suite_object: Suite object with suite level data
        :param metadata: Dict of data of variables to be logged with test
        :return: Models.Test element
        """
        if metadata is None:
            metadata = {}
        test_name = self.test_tag["name"].strip()
        test_name = self.soup_support.get_xml_unescape(test_name)
        time_support = TimeSupport(self.soup_support)
        time_status_dict = time_support.get_times_and_status(self.test_tag)
        step_parser = StepParser(self.test_tag, self.soup_support, self.report_path)
        steps_data_dict = step_parser.fetch_steps_data(data_driven=data_driven,
             action=action)
        template_keyword = ""
        for step_detail in steps_data_dict["steps"]:
            if step_detail.template:
                template_keyword = step_detail.template
                break
        for step_detail in steps_data_dict["steps"]:
            if step_detail.actual:
                step_detail.actual = self._final_actual_values_check(step_detail.actual,
                    self.extra_variables)
            if not data_driven and step_detail.variables:
                step_detail.variables = self._final_variables_values_check(step_detail.variables,
                    self.extra_variables)
            if not data_driven and step_detail.description:
                step_detail.description = self._final_actual_values_check(step_detail.description,
                    self.extra_variables)
        test_doc = self.soup_support.get_child_element_text(self.test_tag, "doc")
        test_doc = self.soup_support.get_xml_unescape(test_doc)
        test_jira_id, test_doc = self.soup_support.get_doc_extraction(
            JIRA_ID, test_doc, suite_object.jira_id)
        test_label_id, test_doc = self.soup_support.get_doc_extraction(
            LABEL_ID, test_doc, suite_object.label_id)
        test_images, test_tag_data = self._read_test_images_and_tags(self.test_tag)
        test_osname = self.get_test_os(metadata)
        if isinstance(suite_object.suite_variables, dict):
            suite_object.suite_variables.update(steps_data_dict["Step Variables"])
        else:
            suite_object.suite_variables = steps_data_dict["Step Variables"]
        suite_object.suite_variables.update(metadata)
        test_variables = self._get_logging_variables(suite_object.suite_variables)
        test_obj = Test(
                        name=test_name,
                        steps=steps_data_dict["steps"],
                        result=time_status_dict["status"],
                        attachment=test_images,
                        doc=test_doc,
                        start_time=time_status_dict["start_time"],
                        end_time=time_status_dict["end_time"],
                        story_jira_id=test_jira_id,
                        label_id=test_label_id,
                        template_keyword=template_keyword,
                        data_driven_test=steps_data_dict["data driven check"],
                        variables=test_variables,
                        extra_variables_dict = self.extra_variables,
                        test_tags=test_tag_data,
                        test_os=test_osname)
        return test_obj

    @staticmethod
    def get_test_os(metadata):
        test_osname = platform.system()
        if 'metadata' in list(metadata.keys()) and 'platform' in list(metadata['metadata'].keys()) and metadata['metadata']['platform']:
            test_osname = metadata['metadata']['platform']
        return test_osname

    @staticmethod
    def _update_user_or_robot_variable_keys(key, variables, data_dict):
        """
        Updats user or robot variable keys into variables dict
        :param key: Name of the variable
        :param variables: Dict containing variable value
        :param data_dict: Dict to be updated with key, value pair
        """
        if key in ["USER", "ROBOT"]:
            for variable in variables[key]:
                data_dict[key][variable] = variables[key][variable]

    @staticmethod
    def _update_inner_user_or_robot_variable_keys(key, variables, data_dict):
        """
        Updats user or robot variable keys into variables dict
        :param key: Name of the variable
        :param variables: Dict containing variable value
        :param data_dict: Dict to be updated with key, value pair
        """
        if key in ["Keyword_Name_Variables", "Arguments", "Assign_Variable"]:
            for second_key in variables[key]:
                if second_key in ["USER", "ROBOT"]:
                    for second_variable in variables[key][second_key]:
                        data_dict[second_key][second_variable] = \
                            variables[key][second_key][second_variable]
        elif key == "metadata":
            data_dict[key] = variables[key]

    def _get_logging_variables(self, variables):
        """
        Fetches variables in the format of USER and ROBOT keys
        :param variables: dict of variables
        :return: updated dict of variables
        """
        data_dict = {"USER": {}, "ROBOT": {}}
        for key in variables:
            self._update_user_or_robot_variable_keys(key, variables, data_dict)
            self._update_inner_user_or_robot_variable_keys(key, variables, data_dict)
        return data_dict

    def _read_test_images_and_tags(self, test_tag):
        """
        Reads images and tags for the test
        :param test_tag: Test tag being processed
        :return: List of images and Tags used to execute the test
        """
        image_support = Images(self.soup_support, self.report_path)
        test_images = image_support.get_images(self.test_tag, ntpath.dirname(self.report_path),
                                               recursive=False)
        test_tag_data = []
        tag_elements = self.soup_support.read_inner_tags_of_type(test_tag, "tags")
        if tag_elements:
            tag_items = self.soup_support.read_inner_tags_of_type(tag_elements[0], "tag")
            for inner_test_tag_id in tag_items:
                test_tag_data.append(inner_test_tag_id.string.strip())
        return test_images, test_tag_data

    def _final_actual_values_check(self, actual, test_variables):
        """
        Checks if variable names are still present in actual string and
        if it exists in the test variables, it will add the value here
        """
        if '{' in actual and '}' in actual:
            for variable_name in test_variables:
                if variable_name and variable_name in actual and test_variables[variable_name]:
                    actual = actual.replace(variable_name, test_variables[variable_name])
        return actual

    def _final_variables_values_check(self, step_variables, test_variables):
        """
        Checks if variable names are still present in actual string and
        if it exists in the test variables, it will add the value here
        """
        var_list = ['Keyword_Name_Variables', 'Arguments', 'Assign_Variable']
        for var_dict_level in var_list:
            if var_dict_level in step_variables:
                step_variables = self._replace_step_variables(step_variables[var_dict_level], test_variables)
        return step_variables

    def _replace_step_variables(self, step_variables_at_level, test_variables):
        """
        Replace step variables with test variables
        """
        for level_type in step_variables_at_level:
            for variable_name in step_variables_at_level[level_type]:
                if variable_name in test_variables and test_variables[variable_name]:
                    step_variables_at_level[level_type][variable_name] = \
                                                    test_variables[variable_name]
        return step_variables_at_level
