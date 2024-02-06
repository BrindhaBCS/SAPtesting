"""
Provides a xml processing starting instance. This supports in creating report
for Robot framework test results
"""
from Support.soup_support import Soup
from Support.metadata_support import MetadataSupport
from Model_Parser.test_parser import TestParser
from Model_Parser.test_suite_parser import TestSuiteParser
import copy


class XmlRobot:
    """
    Starts execution of Robot Output Result which is the default Output.xml file
    generated through Robot Framework results
    """
    def __init__(self, report_path, data_driven, template, action, parent_folder=""):
        """
        Initialized by passing the Robot Framework output xml report path to be processed
        :param report_path: Absolute path to Json report.
        """
        self.report_path = report_path
        self.data_driven = data_driven
        self.template_test = template
        self.action = action
        self.soup_support = Soup(self.report_path)
        self.meta_data_support = MetadataSupport(self.soup_support.bs_soup)
        self.parent_folder = parent_folder
        self.suites = []

    def parse_results(self):
        """
        Parses xml results file read from Robot Framework output.xml results
        :return: suite object list read from parsing robot data

        Test formats can be one of the following:

        1. Regular tests
            - output.xml test format is test tag where
                level1 keywords = step description and
                level2 keywords = step expected
            - test tags have unique names
            - uploader creates one test object per test/test execution

        2. Template tests
            - output.xml test format is test tag with
                level1 keywords (multiple) = test template,
                level2 keywords = step description and
                level3 keywords = step expected
            - iterations are stored under single test tag with one or more
                level1 keywords with same name
            - if -dd parameter is passed
                uploader creates one test object per level1 keyword
                (1 generic overall test, 1 test execution
                    per template iteration)
            - if -dd parameter not passed
                uploader combines all test steps into one test object
                (1 test, 1 test execution)

        3. Datadriven library tests
            - output.xml test format is test tag with
                level1 keyword (single) = test template,
                level2 keywords = step description and
                level3 keywords = step expected
            - iterations are stored as one or more test tags with same name
            - if -dd parameter is passed
                uploader creates one test object per test
                (1 generic overall test, 1 test execution
                    per test tag)
            - if -dd parameter not passed
                uploader combines all tests steps into one test object
                (1 test, 1 test execution)    
        """
        dependencies = self.meta_data_support.get_dependencies()
        metadata_dict = self.meta_data_support.get_meta_data_combined_information()
        all_tests = self.soup_support.bs_soup.find_all('test')
        test_counter = 0
        while test_counter < len(all_tests):
            test = all_tests[test_counter]
            count_tests = 1
            variables = self.get_variables(test)
            suite_parser = TestSuiteParser(test, self.soup_support, self.parent_folder)
            suite_object = suite_parser.fetch_test_suite_data(dependencies, self.data_driven, action=self.action)
            data_driven_list = self._check_if_suite_data_driven(test)
            if data_driven_list and not self.data_driven:
                print("WARNING: Use -dd parameter for datadriven/template tests to avoid payload too large issues and timeouts")
                if data_driven_list['type'] == 'datadriver':
                    test = self._combine_datadriven_test_steps(data_driven_list, test)
                else:
                    test = self._combine_template_test_steps(data_driven_list, test)
                count_tests = data_driven_list['test_number']
                variables = {} # Will be processed at later stage
            test_status = test.find_all('status')
            if test_status[-1]['status'] == "SKIP":
                print("Skipped test found - excluding from upload")
            else:
                test_objects = self._create_test_object_list(test, suite_object, metadata_dict, variables)
                self._update_suite_object(suite_object, test_objects)
            test_counter += count_tests

    def _create_test_object_list(self, test, suite_object, metadata_dict, variables):
        test_objects = []
        template_test = self._check_template_test(test)
        if template_test and self.data_driven:
            template_test_objects = self._process_individual_template_test(template_test, test, suite_object, metadata_dict)
            test_objects = template_test_objects
        else:
            test_parser = TestParser(test, self.soup_support, self.report_path, variables)
            test_object = test_parser.fetch_test_data(
                suite_object, metadata_dict, data_driven=self.data_driven, action=self.action)
            test_objects.append(test_object)
        return test_objects

    def _replace_variables_in_keywords(self, child_keywords, updated_keywords, keyword_variables=None):
        for keyword_level1 in child_keywords:
            if not keyword_variables:
                keyword_variables = self.get_variables(keyword_level1)
            if not ('type' in keyword_level1.parent.attrs or 'type' in keyword_level1.attrs):
                keyword_level1 = self.update_keyword_variables(keyword_level1, keyword_variables)
                for keyword_level2 in keyword_level1.find_all('kw', recursive = False):
                    keyword_level2 = self.update_keyword_variables(keyword_level2, keyword_variables)
                updated_keywords.append(keyword_level1)
        return updated_keywords

    def _combine_template_test_steps(self, data_driven_list, test):
        """
        Combines keywords from template tests into a single test
        :param data_driven_list: datadriven test details
        :param test: overall test
        :return: new test with combined and updated keywords
        """
        new_test = test
        test_template_combined_keywords = []
        for template_keyword in data_driven_list['object_list']:
            for keyword in new_test.find_all("kw", recursive=False):
                keyword.extract()
            updated_keywords = []
            keyword_variables = self.get_variables(template_keyword)
            child_keywords = template_keyword.find_all('kw', recursive = False)
            updated_keywords = self._replace_variables_in_keywords(child_keywords, updated_keywords, keyword_variables)
            test_template_combined_keywords += updated_keywords
        for item in test_template_combined_keywords:
            new_test.append(item)
        return new_test

    def _combine_datadriven_test_steps(self, data_driven_list, test):
        """
        Combines keywords from datadriven tests into a single test
            - not recommended for large number of tests since it can result
              in payload sizes that may be too large for endpoints
        :param data_driven_list: datadriven test details
        :param test: overall test
        :return: new test with combined and updated keywords
        """
        new_test = copy.copy(test)
        for keyword in new_test.find_all("kw", recursive=False):
            keyword.extract()
        test_combined_keywords = []
        for template_test in data_driven_list['object_list']:
            updated_keywords = []
            for template_keyword in template_test.find_all('kw', recursive = False):
                keyword_variables = self.get_variables(template_keyword)
                child_keywords = template_keyword.find_all('kw', recursive = False)
                updated_keywords = self._replace_variables_in_keywords(child_keywords, updated_keywords, keyword_variables)
            test_combined_keywords += updated_keywords
        for item in test_combined_keywords:
            new_test.append(item)
        return new_test

    def _update_variables_in_test(self, test):
        """
        Update level1, level2, and level3 keywords with variables replaced with values
        """
        for keyword in test.find_all("kw", recursive=False):
            keyword_variables = self.get_variables(keyword)
            if not ('type' in keyword.parent.attrs or 'type' in keyword.attrs):
                keyword = self.update_keyword_variables(keyword, keyword_variables)
                for keyword_level2 in keyword.find_all('kw', recursive = False):
                    keyword_level2 = self.update_keyword_variables(keyword_level2, keyword_variables)
                    for keyword_level3 in keyword_level2.find_all('kw', recursive = False):
                        keyword_level3 = self.update_keyword_variables(keyword_level3, keyword_variables)

    def update_keyword_variables(self, keyword, keyword_variables):
        """
        Replaces variables found in keyword names (steps) with values
        and replaces lower level arg variables with values
        :param keyword: unprocessed keyword
        :param keyword_variables: dictionay containing variable key:value pairs under the keyword
        :return: keyword with variables replaced with values
        """
        keyword_text = keyword.attrs["name"]
        for item in keyword_variables:
            keyword_text = keyword_text.replace(item, keyword_variables[item])
        keyword["name"] = keyword_text
        for arg in keyword.find_all('arg', recursive = False):
            arg_text = arg.string
            for item in keyword_variables:
                arg_text = arg_text.replace(item, keyword_variables[item])
            arg.string = arg_text
        return keyword

    def get_variables(self, object):
        """
        Parses xml results file read from Robot Framework output.xml results
        :return: suite object list read from parsing robot data
        """
        variables_dict = {}
        all_keywords = object.find_all('kw')
        for keyword in all_keywords:
            arg_list, var_list, msg_list = self.setup_keyword_component_lists(keyword)
            #print(keyword["name"], [len(arg_list), len(var_list), len(msg_list)], arg_list, var_list, msg_list)
            if arg_list and msg_list:
                if len(arg_list) == len(msg_list) and len(arg_list) == 1 and arg_list[0].find('{') >= 0:
                    variables_dict = self.get_variables_from_single_arg_and_msg(arg_list[0], msg_list[0], variables_dict)
                else:
                    variables_dict = self.check_message_with_assignment_equals(msg_list, variables_dict)
                    for arg in arg_list:
                        variables_dict = self.check_message_with_assignment_colon(arg, msg_list, variables_dict)
        final_variables_dict = self._replace_null_variable(variables_dict)
        return final_variables_dict
    
    def _update_suite_object(self, suite_object, test_objects):
        """
        Add test objects to suite_object
        """
        if suite_object.tests is None:
            suite_object.tests = test_objects
        else:
            for test_object in test_objects:
                suite_object.tests.append(test_object)
        if suite_object not in self.suites:
            self.suites.append(suite_object)

    def _check_if_suite_data_driven(self, test):
        """
        Checks if the test under a suite is data driven
         (using datadriver library or template tests). 
         It will be used to combine all such tests together
         for processing under a single report.
        :param test: overall test
        :return: data-driven test details
        """
        suite = test.parent
        data_driven_tests = {}
        tests_under_suite = suite.findChildren("test", recursive=False)
        if len(tests_under_suite) > 1:
            all_tests_name = [x.attrs["name"] for x in tests_under_suite]
            for test_name in all_tests_name:
                test_duplicate = self._check_for_duplicates(all_tests_name, test_name)
                if len(test_duplicate) > 1:
                    data_driven_tests['type'] = 'datadriver'
                    data_driven_tests['template'] = test_name
                    data_driven_tests['test_number'] = len(test_duplicate)
                    data_driven_tests['object_list'] = tests_under_suite
        if not data_driven_tests:
            tests_under_test = test.findChildren('kw', recursive=False)
            top_level_keywords = [x.attrs['name'] for x in tests_under_test if 'type' not in x.attrs]
            for keyword_name in top_level_keywords:
                keyword_duplicate = self._check_for_duplicates(top_level_keywords, keyword_name)
                if (len(top_level_keywords) > 1 and len(keyword_duplicate) == len(top_level_keywords)) \
                        or (len(top_level_keywords) == 1 and self.template_test):
                    data_driven_tests['type'] = 'template'
                    data_driven_tests['template'] = keyword_name
                    data_driven_tests['test_number'] = 1
                    data_driven_tests['object_list'] = tests_under_test
                    break
        return data_driven_tests

    @staticmethod
    def _check_for_duplicates(all_tests_name, test_name):
        duplicates_list = []
        for position, element in enumerate(all_tests_name):
            if element == test_name:
                duplicates_list.append(position)
        return duplicates_list

    def _check_template_test(self, test):
        """
        Checks if the test under a suite contains template keywords. It creates test objects
        so that they can be processed separately
        :param test: soup of tag with name test
        :return: list of test objects for template iterations
        """
        template_keyword = ""
        keywords_under_test = test.findChildren("kw", recursive=False)
        all_keywords_name = []
        if len(keywords_under_test) > 1:
            all_keywords_name = [x.attrs["name"] for x in keywords_under_test if not "type" in x.attrs]
            if len(all_keywords_name) > 1 and all_keywords_name.count(all_keywords_name[0]) == len(all_keywords_name):
                template_keyword = all_keywords_name[0]
        return template_keyword

    def _process_individual_template_test(self, template_keyword, test, suite_object, metadata_dict):
        """
        Splits test containing template iterations into individual tests
        """
        template_test_objects = []
        if template_keyword:
            for template_iteration in test.find_all("kw", {"name": template_keyword}):
                new_test = test
                for keyword in new_test.find_all("kw", recursive=False):
                    keyword.extract()
                new_test.insert(0, template_iteration)
                template_variables = self.get_variables(template_iteration)
                test_parser = TestParser(new_test, self.soup_support, self.report_path, template_variables)
                test_object = test_parser.fetch_test_data(
                    suite_object, metadata_dict, data_driven=self.data_driven, action=self.action)
                template_test_objects.append(test_object)
        return template_test_objects

    def setup_keyword_component_lists(self, keyword):
        """
        Generate lists containing arg and msg tags for the keyword
        """
        arg_list = []
        var_list = []
        msg_list = []
        arguments = keyword.find_all("arg", recursive=True)
        variables = keyword.find_all("var", recursive=True)
        messages = keyword.find_all("msg", recursive=True)
        for arg in arguments:
            arg_list.append(arg.string.replace('\n', ' '))
        for var in variables:
            var_list.append(var.string.replace('\n', ' '))
        for msg in messages:
            if 'Argument types are' not in msg.string and 'selenium-screensot' not in msg.string:
                msg_list.append(msg.string.replace('\n', ' '))
        return arg_list, var_list, msg_list

    def get_variables_from_single_arg_and_msg(self, arg, msg, variables_dict):
        """
        E.g. 'Log' keyword containing 1 arg sentence containing variable names and
         corresponding msg sentence containing variable values
        Words in the 2 sentences are compared, with some words matching and others
         checked for variable name and assigned value
        Ignore args only containing variable name for now (matches_found must be > 0 
         to indcate corresponding arg and msg sentences)
        """
        arg_string_list = arg.split()
        msg_string_list = msg.split()
        matches_found, var_dict = self._get_split_message_variables(arg_string_list, msg_string_list)
        var_dict_multi = self._get_multi_part_message_variables(arg, msg)
        if matches_found > 0 and var_dict:
            for arg_name in var_dict:
                if arg_name not in variables_dict:
                    variables_dict[arg_name] = var_dict[arg_name]
        for arg_name in var_dict_multi:
            if arg_name not in variables_dict:
                variables_dict[arg_name] = var_dict_multi[arg_name]
        return variables_dict

    def _get_split_message_variables(self, arg_string_list, msg_string_list):
        """
        Get variables where variable name in arg matches single variable value in msg
        """
        matches_found = 0
        var_dict = {}
        if len(arg_string_list) == len(msg_string_list):
            for i, word in enumerate(arg_string_list):
                if word == msg_string_list[i]:
                    matches_found += 1
                else:
                    if '{' in word and '}' in word and word not in var_dict:
                        var_dict[word] = msg_string_list[i]
        return matches_found, var_dict

    def _get_multi_part_message_variables(self, arg, msg):
        """
        Get variables where variable name in arg matches multi-part variable value in msg
        (variable value has one or multiple space-separated components)
        If arg is variable name only, then full msg should be passed as the variable value
        If arg and msg have common text surrounding the variables, then isolate and remove these
        """
        var_dict = {}
        arg_list = []
        msg_list = []
        arg_list = self._process_arg_variables(arg)
        arg_list, msg_list, cor_msg = self._process_msg_variables(arg, arg_list, msg)
        if len(arg_list) == len(msg_list) and cor_msg:
            for i, item in enumerate(arg_list):
                var_dict[item] = msg_list[i]
        return var_dict

    def _process_arg_variables(self, arg):
        """
        Breakdown arg string to isolate text and variables,
        creating list of common text and variable names.
        """
        var_string = ''
        non_var_string = ''
        arg_list = []
        var = False
        for char in arg:
            arg_list, var_string, non_var_string, var = self._process_arg_char(var, char, arg_list, var_string, non_var_string)
        if non_var_string:
            arg_list.append(non_var_string)
        if var_string:
            arg_list.append(var_string)
        return arg_list

    def _process_arg_char(self, var, char, arg_list, var_string, non_var_string):
        if char == '$':
            if non_var_string:
                arg_list.append(non_var_string)
                non_var_string = ''
            var_string = char
            var = True
        elif char == '}':
            var_string += char
            var = False
            if var_string:
                arg_list.append(var_string)
                var_string = ''
        else:
            if var:
                var_string += char
            else:
                non_var_string += char
        return arg_list, var_string, non_var_string, var

    def _process_msg_variables(self, arg, arg_list, msg):
        """
        Breakdown msg string to isolate text and variables,
        creating lists of common text and variable values.
        cor_msg checks if arg/msg contain common text, or contain single variable name/value pair
        (to confirm whether arg and msg correspond correctly)
        """
        replace_string = 'xxx000'
        for item in arg_list:
            if '$' not in item:
                msg = msg.replace(item, replace_string, 1)
                arg = arg.replace(item, replace_string, 1)
        cor_msg = replace_string in msg or (len(arg_list) == 1 and '$' in arg_list[0])
        msg_list = msg.split(replace_string)
        arg_list = arg.split(replace_string)
        return arg_list, msg_list, cor_msg

    def check_message_with_assignment_equals(self, msg_list, variables_dict):
        """
        E.g Keyword msg containing variable assignment "${site_url} = 'https://www.example.com'"
        """
        for msg in msg_list:
            msg_split = msg.split()
            if len(msg_split) > 0 and (msg_split[0].startswith('${') or msg_split[0].startswith('@{') or msg_split[0].startswith('&{')) \
                    and msg_split[0].endswith('}') and msg_split[1] == "=":
                arg_name = msg_split[0]
                msg_split_at_equals = msg.split(" = ")
                if len(msg_split_at_equals) > 1 and arg_name not in variables_dict:
                        variables_dict[arg_name] = msg_split_at_equals[1]
        return variables_dict

    def check_message_with_assignment_colon(self, arg, msg_list, variables_dict):
        """
        E.g Keyword containing data file variable "Dev.urls.site_url: 'https://www.example.com'"
        Full variable name is extracted from the arg list and assiged to msg value
        """
        if arg.find('var(\'') >= 0 and arg.find('}') >= 0:
            i0 = arg.find('{')
            i0 -= 1     # Start of full variable name
            i1 = arg.find('}')
            i1 += 1     # End of full variable name
            i2 = arg.find('var(\'')
            i2 += 5     # Start of inner variable name
            i3 = arg.find('}')
            i3 -= 2     # End of inner varaible name
            arg_name = arg[i0:i1]
            arg_inner = arg[i2:i3]
            arg_inner = arg_inner + ':'
            for msg in msg_list:
                if arg_inner in msg:
                    msg_split = msg.split(arg_inner)
                    if len(msg_split) > 1 and arg_name not in variables_dict:
                        variables_dict[arg_name] = msg_split[1].split()[0].strip()
                    break
        return variables_dict

    def _replace_null_variable(self, variables_dict):
        final_variables_dict = {}
        for item in variables_dict:
            if item:
                if not variables_dict[item]:
                    final_variables_dict[item] = ' '
                else:
                    final_variables_dict[item] = str(variables_dict[item]).strip()
        return final_variables_dict
