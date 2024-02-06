"""
Parses for data that reside under a step in Robot Xml report
"""
import ntpath
from Support.times_support import TimeSupport
from Support.images_support import Images
from Models.step_model import Step
from .parse_keywords import ParseKeywords


class StepParser:
    """
    Parses for data under a step identified by tag kw
    """
    def __init__(self, test_tag, soup_support, report_path):
        """
        Initializes StepParser using a soup xml tag to identify test
        :param test_tag: bs4.Element.Tag object to identify the test to parse
        :param soup_support: Support.Soup object to support with step data processing
        """
        self.test_tag = test_tag
        self.soup_support = soup_support
        self.time_support = TimeSupport(self.soup_support)
        self.image_support = Images(self.soup_support, report_path)
        self.report_path = report_path

    def fetch_steps_data(self, data_driven, action):
        """
        Fetches step data read under the initialized keyword
        :return: Models.Step element
        """
        step_tags_recursive = self.soup_support.get_all_keyword_tags(self.test_tag)
        data_driven_check = {}
        steps_data_dict = self._read_steps_data(data_driven_check, data_driven, action, step_tags_recursive)
        steps_data_dict["data driven check"] = data_driven_check
        return steps_data_dict

    def _read_steps_data(self, data_driven_check, data_driven=False, action="", all_kw_tags=None):
        """
        Reads information for the step data based on if it is data driven test.
        :param data_driven: Check to ensure if the test is data driven
        :param all_kw_tags: Recursive list of keyword tags identifying as steps
        :return: Dictionary of data from reading the step of format:
                    {"steps": List of steps,
                     "Step Variables": dictionary of all step variables}
        """
        all_step_variables = {"USER": {}, "ROBOT": {}}
        steps = []
        if not (data_driven_check or data_driven):
            steps_object, steps_variables = self._read_steps_data_detail(all_kw_tags)
            all_step_variables.update(steps_variables)
            steps.extend(steps_object)
        else:
            for counter, data_driven_test in enumerate(all_kw_tags):
                parent_keyword = list(all_kw_tags.keys())[counter]
                parent_keyword_parser = ParseKeywords(parent_keyword)
                parent_keyword_parser.setup_variable_data()
                steps_object, steps_variables = self._read_steps_data_detail(
                    all_kw_tags[data_driven_test], data_driven=data_driven, action=action,
                     execution_counter=counter+1, parent_keyword_parser=parent_keyword_parser)
                steps.extend(steps_object)
                all_step_variables.update(steps_variables)
        steps_data_dict = {"steps": steps,
                           "Step Variables": all_step_variables}
        return steps_data_dict

    def _read_steps_data_detail(self, steps_keyword_dict, data_driven=False, action="", execution_counter=1,
                                parent_keyword_parser=None):
        """
        Reads step information data based on step level keyword and one level inner keyword
        :param steps_keyword_dict: Recursive dict of Keyword tags under a test identifying steps
        :param execution_counter: Number of execution to be added to the step for templated test
        :param parent_keyword_parser: Parent keyword parser in case it is data driven test
        :return: steps objects in a list
        """
        steps = []
        all_step_variables = {}
        for step in steps_keyword_dict:
            keyword_parser = ParseKeywords(step)
            keyword_parser.setup_variable_data()
            step_time_status_dict = self.time_support.get_times_and_status(step)
            step_status = step_time_status_dict["status"]
            step_detail = keyword_parser.get_step_details(parent_keyword_parser,
                step_status, self.time_support, data_driven=data_driven, action=action)
            parent_keyword_parser = None   # Reset after one use
            images = self.image_support.get_images(step, ntpath.dirname(self.report_path))
            steps.append(Step(
                description=step_detail["description"],
                expected=step_detail["expected"],
                actual=step_detail["actual"],
                template=step_detail["template"],
                status=step_status,
                attachment=images,
                start_time=step_time_status_dict["start_time"],
                end_time=step_time_status_dict["end_time"],
                execution_counter=execution_counter,
                variables=step_detail["Arguments"]))
            keyword_parser.update_variable_dicts(all_step_variables, step_detail["Arguments"])
        return steps, all_step_variables
