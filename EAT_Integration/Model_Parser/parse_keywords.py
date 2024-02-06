"""
This module parses keywords for fetching details for it
"""
import re
from . import variables as parse_variables
from difflib import SequenceMatcher

class ParseKeywords:
    """
    Parses keywords for their details to be added to a step
    """
    def __init__(self, keyword, recursive=True):
        """
        Initializes ParseKeywords
        :param keyword: Keyword to parse for data. BeautifulSoup element type
        """
        self.keyword = keyword
        self.name = ""
        self.arguments = []
        self.variables = {"Keyword_Name_Variables": {},
                          "Arguments": {},
                          "Assign_Variable": {}}
        self.substituted_values = ""
        self.recursive = recursive

    def setup_variable_data(self):
        """
        Finds variables in keyword name, arguments and assign variables.
        Also builds their value in a dict.
        """
        self.name = self.keyword.attrs.get("name", "")
        self.variables["Keyword_Name_Variables"] = self._get_variables_from_string(self.name)
        assign = self.keyword.findChild("assign", recursive=False)
        assign_list = self.keyword.find_all("var", recursive=False)
        if assign:
            self.variables["Assign_Variable"] = self._get_variables_from_string(
                assign.find("var").string)        
        elif assign_list:
            for assign in assign_list:
                self.variables["Assign_Variable"] = self._get_variables_from_string(
                    assign.string.strip())
        arguments = self.keyword.findChild("arguments", recursive=False)
        if arguments:
            arguments = arguments.find_all("arg")
        else:
            arguments = self.keyword.find_all("arg", recursive=False)
        if arguments:
            for arg in arguments:
                argument_string = arg.string.strip()
                self.arguments.append(argument_string)
                argument_name_dict = self._get_variables_from_string(argument_string)
                self._add_default_variable_dict(self.variables["Arguments"])
                self.variables["Arguments"]["ROBOT"].update(argument_name_dict["ROBOT"])
                self.variables["Arguments"]["USER"].update(argument_name_dict["USER"])
                self.variables["Arguments"]["STRING"] = argument_string
        self._get_variable_values()

    def _add_all_message_recursively(self, step, messages):
        """
        Recursively reads all messages strings in a list within a keyword step
        :param step: Keyword step under which to look for message string recursively
        :param messages: List of messages built through recursive parsing
        """
        messages.extend([msg.getText() for msg in step.findChildren(
            "msg", recursive=False) if "<img src=" not in msg.getText()])
        for keyword in step.findChildren("kw", recursive=False):
            self._add_all_message_recursively(keyword, messages)

    def _add_all_messages_to_actual_if_fail(self, status, step, actual):
        """
        Returns a string of information containing messages from the step if the
        message is not used any of the variables yet
        :param status: Status to check if the step failed
        :param step: Step object
        :param actual: Actual step value to be updated with error messages on failure
        :return: Updated actual string
        """
        if status[:4].upper() == "FAIL":
            messages = []
            self._add_all_message_recursively(step, messages)
            for error_message in messages:
                start_debug_message = "\n\nDebug messages:"
                if start_debug_message not in actual:
                    actual += start_debug_message
                if error_message not in actual:
                    actual += "\n" + error_message
        return actual

    def get_step_details(self, parent_keyword_parser=None, step_status="Passed",
                         time_support=None, data_driven=False, action=""):
        """
        After parsing the values for the step this returns actual
        expected, description and variables for the keyword
        :param parent_keyword_parser: In data driven test this represents parent
            keyword object
        :param step_status: The step status read from the step keyword
        :param time_support: The object to handle fetching time and status for step
        :return: dict of format: {actual: "", expected: "", variables: "",
                                    description: ""}
        """
        parent_expected = ""
        if parent_keyword_parser:
            parent_expected = self._get_expected_details(parent_keyword_parser)
        if data_driven:
            expected = self._get_expected_details(self)
        else:
            expected = parent_expected + self._get_expected_details(self)
        description = ""
        actual = expected

        inner_variables = {}
        for keyword in self.keyword.findChildren("kw", recursive=False):
            _inner_keyword_parser = ParseKeywords(keyword)
            _inner_keyword_parser.setup_variable_data()
            self.update_variable_dicts(inner_variables, _inner_keyword_parser.variables)
            inner_description = self._get_expected_details(_inner_keyword_parser).strip()
            inner_step_time_status_dict = time_support.get_times_and_status(keyword)
            inner_step_status = inner_step_time_status_dict["status"]
            description = description.strip() + "\n" + inner_description
            actual = actual.strip() + "\n" + inner_description
            actual = self._substitute_actual_variables(actual, inner_variables)
            actual = self._add_all_messages_to_actual_if_fail(
                inner_step_status, keyword, actual)
            if _inner_keyword_parser.substituted_values and \
                    not actual.endswith(_inner_keyword_parser.substituted_values):
                actual += "\n" + _inner_keyword_parser.substituted_values
        self._add_default_variable_dict(self.variables["Arguments"])
        variable_update_required = not (data_driven and action == "Create_Test")
        if variable_update_required:
            self.update_variable_dicts(self.variables, inner_variables)
        if parent_keyword_parser and variable_update_required:
            self.update_variable_dicts(self.variables, parent_keyword_parser.variables)
        actual = self._substitute_actual_variables(actual)
        actual = self._add_all_messages_to_actual_if_fail(step_status, self.keyword, actual)
        template_string = ""
        if parent_expected:
            template_string = "Template details: " +  str(parent_expected).strip()
        return {"actual": actual,
                "expected": expected,
                "template": template_string,
                "Arguments": self.variables,
                "description": description}

    @staticmethod
    def _check_var_type_not_in_parent_and_type_string(
            var_type, var_level, dict_parent, dict_child):
        """
        Checks variable type in parent dict and of type string or
        in just type string. Sets the dict_parent value if condition met
        :param var_type: Type of variable
        :param var_level: Level of variable
        :param dict_parent: Parent dictionary to be updated
        :param dict_child: Child dictionary to check value
        :return: True if continue without processing further loop
        """
        check_continue = False
        if var_type not in dict_parent[var_level]:
            if var_type == "STRING":
                dict_parent[var_level][var_type] = \
                    dict_child[var_level][var_type]
                check_continue = True
            else:
                dict_parent[var_level].setdefault(var_type, {})
        if var_type == "STRING":
            check_continue = True
        return check_continue

    def update_variable_dicts(self, dict_parent, dict_child):
        """
        Updates dict parent with data inside dict child
        :param dict_parent: dict of variables
        :param dict_child: dict of variables
        """
        for var_level in dict_child:
            if var_level not in dict_parent:
                dict_parent.setdefault(var_level, {})
            for var_type in dict_child.get(var_level, {}):
                if self._check_var_type_not_in_parent_and_type_string(
                        var_type, var_level, dict_parent, dict_child):
                    continue
                for variable in dict_child[var_level][var_type]:
                    dict_parent[var_level][var_type][variable] = \
                        dict_child[var_level][var_type][variable]

    @staticmethod
    def _add_default_variable_dict(data_dict):
        """
        Adds default keys ROBOT and USER in data_dict
        :param data_dict: dict to update with keywords
        """
        data_dict.setdefault("ROBOT", {})
        data_dict.setdefault("USER", {})

    @staticmethod
    def _get_expected_details(keyword_parser):
        """
        Gets string representation from name and arguments list
        :param keyword_parser: Parser object
        :return: String representation of the expected details
        """
        name = keyword_parser.name
        arguments = keyword_parser.arguments
        assign_variable = keyword_parser.variables.get("Assign_Variable", {}).get("STRING", "")
        if assign_variable:
            assign_variable += " = "
        return assign_variable + name + "\n" + ", ".join(arguments) + "\n"

    def _substitute_actual_variables(self, actual, inner_variables=None):
        """
        Substitutes the actual value for the step by replacing parameter with
        their logged values.
        :param actual: Actual string comprised of expected and actual values
        :param inner_variables: Variables processed till this point in execution
        :return: actual string substituted for variable values
        """
        if not inner_variables:
            inner_variables = self.variables.copy()

        variable_dict = inner_variables["Arguments"].get("USER", {}).copy()
        variable_dict.update(inner_variables["Arguments"].get("ROBOT", {}))
        variable_dict.update(inner_variables["Keyword_Name_Variables"].get("ROBOT", {}))
        variable_dict.update(inner_variables["Keyword_Name_Variables"].get("USER", {}))
        variable_dict.update(inner_variables["Assign_Variable"].get("ROBOT", {}))
        variable_dict.update(inner_variables["Assign_Variable"].get("USER", {}))
        for variable_name in variable_dict:
            if variable_name in actual and variable_dict[variable_name]:
                actual = actual.replace(variable_name, variable_dict[variable_name])

        if self.substituted_values:
            actual += "\n" + self.substituted_values
        return actual

    def _get_variables_from_string(self, data_string):
        """
        Fetches variables from keyword name
        :param data_string: String under which to look for variable names
        :return: Variables found inside string in dict format:
            {"USER": ${wvar(' types, "ROBOT": ${var} types}
        """
        variables_found = {"USER": {}, "ROBOT": {}, "STRING": data_string}
        all_variables_start_location = [m.start() for m in re.finditer(
            parse_variables.ALL_VARIABLES_PATTERN, data_string)]
        user_variables_start_location = [m.start() for m in re.finditer(
            parse_variables.USER_VAR_PATTERN, data_string)]
        secured_user_variables_start_location = [m.start() for m in re.finditer(
            parse_variables.USER_VAR_PATTERN_SECURED, data_string)]
        robot_variable_location = sorted(list(set(all_variables_start_location) -
                                         set(user_variables_start_location) -
                                         set(secured_user_variables_start_location)))
        self._build_variables_for_type(
            data_string, robot_variable_location, variables_found.get("ROBOT", {}))
        self._build_variables_for_type(
            data_string, user_variables_start_location, variables_found.get("USER", {}))
        self._build_variables_for_type(
            data_string, secured_user_variables_start_location, variables_found.get("USER", {}))
        return variables_found

    def _build_variables_for_type(self, data_string, location, variable_dict):
        """
        Builds the variable into a dictionary from location sepecified.
        :param data_string: String to look up for variables at location
        :param location: Location where the variables reside
        :param variable_dict: Dictionary to update the values of variables into
        """
        for counter, variable_start in enumerate(location):
            if counter+1 == len(location):   # Last variable
                end_position = None
            else:
                end_position = location[counter+1]
            variable_end = self._find_variable_end(data_string, variable_start, end_position)
            if variable_end and variable_end > variable_start:
                variable_dict.update({data_string[variable_start: variable_end + 1]: ""})

    @staticmethod
    def _find_variable_end(data, start, end):
        """
        Finds the end of variable in data between start and end points
        :param data: Data string to search for variable existence
        :param start: Start point for searching of variable
        :param end: End point until which to find the variable end
        :return: Variable end position found
        """
        end_position = 0
        variable_end_position = data[start: end].find("}")
        if variable_end_position > 0:
            end_position = start + variable_end_position
            if len(data) > end_position + 1 and \
                    data[end_position + 1] == "[":   # Dict variable
                variable_end_position = data[end_position: end].find("]")
                if variable_end_position > 0:
                    end_position = end_position + variable_end_position
        return end_position

    def _get_variable_values(self):
        """
        Looks up for variable names in self.variables and builts their value in it.
        Scenarios in order of scan:
        1. If assign variable then last message logged is its value.
        2. If User defined variable, its value is logged in one of the messages.
        3. If Argument has only variable then match them in order of appearance.
            - If length of messages equal to length of exact arguments then match them in order
            - If greater than 1 argument but only one message remains then match all of them
           to it only in actual data.
           - If not messages but variable still remain to match then look them up in child level
            keywords.
        4. If Argument has other string with it then read it in order of substring match.
        A message once used should then be discarded for assigning value to another variable
        """
        keyword_messages = [x.string for x in self.keyword.findChildren("msg", recursive=False)]
        keyword_messages = self._check_ignore_message_present(keyword_messages)
        if self.variables["Assign_Variable"] and keyword_messages:
            self._find_value_for_assign_variable(keyword_messages[-1])
            keyword_messages = keyword_messages[:-1]
        self._find_value_for_keyword_name_variables(keyword_messages)
        self._find_value_for_arg_variables(keyword_messages)

    def _find_value_for_assign_variable(self, keyword_message):
        """
        Finds the value for the assignment variable from keyword messages.
        Removes the keyword message once it finds that value
        :param keyword_message: Last keyword message to be logged for the keyword
        """
        variable_dict = {}
        if self.variables["Assign_Variable"].get("USER", {}):
            variable_dict = self.variables["Assign_Variable"]["USER"]
        elif self.variables["Assign_Variable"].get("ROBOT", {}):
            variable_dict = self.variables["Assign_Variable"]["ROBOT"]

        if variable_dict:
            variable_key = list(variable_dict.keys())[0]
            variable_value = keyword_message.strip()
            if variable_key + " = " in variable_value:
                variable_value = variable_value.split(variable_key + " = ", 1)[1].strip()
            variable_dict[variable_key] = variable_value

    @staticmethod
    def _find_variable_name(variable_format):
        """
        Reads through the variable format and extracts the variable name from it
        :param variable_format: Variables start/end with ${ / } , ${.var(' / ')}
                or ${.var_secured(' / ')}
        :return: Variable name from the variable format
        """
        variable_name = ""
        user_variables = re.findall(parse_variables.USER_VAR_PATTERN, variable_format)
        secured_user_variables = re.findall(parse_variables.USER_VAR_PATTERN_SECURED,
                                            variable_format)
        names = user_variables + secured_user_variables
        if names:
            variable_name = names[0]
        elif variable_format.startswith("${") and variable_format.endswith("}"):
            variable_name = variable_format[2:-1]
        return variable_name

    @staticmethod
    def _find_user_variable_value(name, messages):
        """
        Looks for variable in messages for value
        :param name: name of the variable to be searched.
        :param messages: List of messages logged at the keyword level
        :return: User variable value
        """
        value = ""
        pop_index = -1
        for counter, message in enumerate(messages):
            var_name = re.findall(parse_variables.USER_VAR_PATTERN, name)
            if not var_name:
                var_name = re.findall(parse_variables.USER_VAR_PATTERN_SECURED, name)
            if var_name:
                find_name = "." + var_name[0] + ": "
                if find_name in message:
                    value = message.split(find_name, 1)[1].strip()
                    pop_index = counter
                    break
        if pop_index >= 0:  # Remove that indexed message
            messages.pop(pop_index)
        return value

    def _find_value_for_keyword_name_variables(self, keyword_messages):
        """
        Finds the value for the keyword name variable from keyword messages.
        Removes the keyword message once it finds that value
        :param keyword_messages: List of messages
        """
        variable_dict = self.variables["Keyword_Name_Variables"].get("USER", {})
        for variable_name in variable_dict:
            variable_dict[variable_name] = self._find_user_variable_value(
                variable_name, keyword_messages)

    @staticmethod
    def _find_value_in_messages(messages, variable_name, should_match=False):
        """
        Checks for variable in messages and removes that message once a match is found
        from the messages list
        :param messages: List of messages read from keyword
        :param variable_name: Name of variable to find value for
        :param should_match: Should exact name: match be found in the message
        :return: Variable value string
        """
        variable_value = ""
        pop_index = -1
        for match_counter, message in enumerate(messages):
            if should_match:
                if variable_name + ": " in message:
                    variable_value = message.split(variable_name + ": ", 1)[1]
                    pop_index = match_counter
                    break
            else:
                variable_value = message.strip()
                pop_index = match_counter
                break
        if pop_index > -1:
            messages.pop(pop_index)
        return variable_value

    def _find_value_for_arg_variables(self, keyword_messages):
        """
        Finds values for remaining arguments passed to the keyword. Scenarios
        3. If Argument has only variable then match them in order of appearance.
            - If no messages but variable still remain to match then look them up in child level
            keywords.
            - If length of messages equal to length of exact arguments then match them in order
            - If greater than 1 argument but only one message remains then match all of them
           to it only in actual data.
            - If Argument has other string with it then read it in order of substring match.
        4. If Argument has other string with it then read it in order of substring match.
        :param keyword_messages: Messages read directly under the keyword
        """
        user_vars_dict = self.variables["Arguments"].get("USER", {})
        robot_vars_dict = self.variables["Arguments"].get("ROBOT", {})
        if self._check_if_arguments_whole():
            initial_keyword_msges_length = len(keyword_messages)
            self._update_substituted_variables_with_single_message(
                keyword_messages, user_vars_dict, robot_vars_dict)
            self._match_no_messages_to_inner_keywords(
                keyword_messages, user_vars_dict, robot_vars_dict, initial_keyword_msges_length
            )
            self._messages_and_arguments_length_differ(
                keyword_messages, user_vars_dict, robot_vars_dict
            )
            self._update_variables_with_matching_argument_length(
                keyword_messages, user_vars_dict, robot_vars_dict
            )
        else:
            self._read_value_from_substrings(keyword_messages)
        self._hide_sensitive_variables()

    def _hide_sensitive_variables(self):
        """
        Hides variables with sensitive names such as passwords
        """
        self._hide_variable_from_dict(self.variables["Keyword_Name_Variables"])
        self._hide_variable_from_dict(self.variables["Arguments"])
        self._hide_variable_from_dict(self.variables["Assign_Variable"])

    @staticmethod
    def _hide_variable_from_dict(data_dict):
        """
        Hides sensitive variable name values in the data_dict
        :param data_dict: Dictionary of expected format:
            {USER: {var: value,..}, ROBOT: {var: value,...}..}
        """
        for variable_name in data_dict.get("USER", {}):
            if variable_name.startswith(parse_variables.MASK_PASSWORD):
                data_dict["USER"][variable_name] = parse_variables.MASKED_VALUE
        for variable_name in data_dict.get("ROBOT", {}):
            if variable_name.startswith(parse_variables.MASK_PASSWORD):
                data_dict["ROBOT"][variable_name] = parse_variables.MASKED_VALUE

    def _check_if_arguments_whole(self):
        """
        Checks if the arguments for the keyword are of type whole i.e. no string
        around argument names
        :return: True if arguments are of type ${var1} ${var2} etc. but False if any
                of them are of type 'This is argument ${arg1}.'
        """
        arguments_whole = True
        variables_dict = self.variables["Arguments"].get("USER", {}).copy()
        variables_dict.update(self.variables["Arguments"].get("ROBOT", {}))
        for variable in variables_dict:
            if variable not in self.arguments:
                arguments_whole = False
                break
        return arguments_whole

    def _match_user_variable_in_keyword_messages(self, user_vars_dict, keyword_messages):
        """
        Matches user variable in keyword messages and updates value in user_vars_dict
        :param user_vars_dict: User variable dict
        :param keyword_messages: Keyword messages at this level
        """
        for user_variable in user_vars_dict:
            if user_vars_dict.get(user_variable, ""):
                continue
            value = self._find_user_variable_value(user_variable, keyword_messages)
            user_vars_dict[user_variable] = value

    def _update_variables_with_matching_argument_length(
            self, keyword_messages, user_vars_dict, robot_vars_dict):
        """
        For the scenario where the length of messages match argument length.
        Match the values exactly and pop them out from keyword_messages.
        This covers for Scenario 3:
        - If length of messages equal to length of exact arguments then match them in order
        :param keyword_messages: list of messages read from keyword.
        :param user_vars_dict: Dictionary containing user variables dictionary
        :param robot_vars_dict: Dictionary containing robot variables dictionary
        """
        # Match user variables
        self._match_user_variable_in_keyword_messages(user_vars_dict, keyword_messages)

        if keyword_messages and \
                len(keyword_messages) == len(robot_vars_dict):
            counter = 0
            for robot_variable in robot_vars_dict:
                variable_value = keyword_messages[counter]
                counter += 1
                robot_vars_dict[robot_variable] = variable_value
            keyword_messages.clear()

    def _update_substituted_variables_with_single_message(
            self, keyword_messages, user_vars_dict, robot_vars_dict):
        """
        For the scenario where the length of messages is 1 and arguments are more than 1
        Add such values to substituted variables and pop out the single message from
        keyword_messages
        This covers for Scenario 3:
        - If greater than 1 argument but only one message remains then match all of them
           to it only in actual data.
        :param keyword_messages: list of messages read from keyword.
        :param user_vars_dict: Dictionary containing user variables dictionary
        :param robot_vars_dict: Dictionary containing robot variables dictionary
        """
        self._match_user_variable_in_keyword_messages(user_vars_dict, keyword_messages)
        total_variables = len(user_vars_dict) + len(robot_vars_dict)
        if len(keyword_messages) == 1 and total_variables > 1:
            self.substituted_values = keyword_messages[0].string.strip()
            keyword_messages.clear()

    @staticmethod
    def _update_innver_variable_dict(inner_variable_dict, user_vars_dict, robot_vars_dict):
        """
        Updates user or robot variable dict with value read.
        :param inner_variable_dict: Variable dict to be present for processing
        :param user_vars_dict: User data variables dict
        :param robot_vars_dict: Robot data variables dict
        """
        if inner_variable_dict:
            for user_variable in user_vars_dict:
                if user_variable in inner_variable_dict["Arguments"].get("USER", {}):
                    user_vars_dict[user_variable] = \
                        inner_variable_dict["Arguments"]["USER"][user_variable]

            for user_variable in robot_vars_dict:
                if user_variable in inner_variable_dict["Arguments"].get("ROBOT", {}):
                    robot_vars_dict[user_variable] = \
                        inner_variable_dict["Arguments"]["ROBOT"][user_variable]

    def _match_no_messages_to_inner_keywords(
            self, keyword_messages, user_vars_dict, robot_vars_dict, init_length):
        """
        For the scenario where the length of messages is 0 and arguments are more than 0
        Look for variable values recursively if required in the next level of keywords
        This covers for Scenario 3:
        - If no messages but variable still remain to match then look them up in child level
            keywords.
        :param keyword_messages: list of messages read from keyword.
        :param user_vars_dict: Dictionary containing user variables dictionary
        :param robot_vars_dict: Dictionary containing robot variables dictionary
        :param init_length: Initial length of the keywords fetched
        """
        if (user_vars_dict or robot_vars_dict) and not keyword_messages and \
                init_length and self.recursive:
            # Only look at next level keywords for such variable value.
            # Hence for next level keywords, recursive=False
            keywords = self.keyword.findChildren("kw", recursive=False)
            inner_variable_dict = {}
            for keyword in keywords:
                _parser = ParseKeywords(keyword, recursive=False)
                _parser.setup_variable_data()
                inner_variable_dict.update(_parser.variables)
            self._update_innver_variable_dict(inner_variable_dict, user_vars_dict, robot_vars_dict)

    @staticmethod
    def _check_ignore_message_present(keyword_messages):
        """
        If match a pattern for ignore messages then ignore such keyword messages
        :param keyword_messages: List of messages to check
        :return: True if message contains ignore strings
        """
        updated_messages = []
        for message in keyword_messages:
            valid_message = True
            check_message = message.replace("\n", "").replace("\r", "")
            for pattern in parse_variables.IGNORE_KEYWORD_MESSAGES_PATTERN:
                matches = re.findall(pattern, check_message)
                if len(matches) == 1 and matches[0] == check_message:
                    valid_message = False
                    break
            if valid_message:
                updated_messages.append(message)
        return updated_messages

    def _messages_and_arguments_length_differ(
            self, keyword_messages, user_vars_dict, robot_vars_dict):
        """
        For the scenario where the length of messages and arguments don't match.
        Match arguments to messages in order. Scenario 3.
        - If Argument has other string with it then read it in order of substring match.
        :param keyword_messages: list of messages read from keyword.
        :param user_vars_dict: Dictionary containing user variables dictionary
        :param robot_vars_dict: Dictionary containing robot variables dictionary
        """
        total_variables = len(user_vars_dict) + len(robot_vars_dict)
        if 1 < len(keyword_messages) != total_variables and total_variables > 1:
            self._match_user_variable_in_keyword_messages(user_vars_dict, keyword_messages)
            if keyword_messages:
                counter = 0
                for robot_variable in robot_vars_dict:
                    robot_vars_dict[robot_variable] = keyword_messages[counter]
                    counter += 1
                    if counter >= len(keyword_messages):
                        break
                keyword_messages.clear()

    def _update_variable_dict_on_keyword_messages(
            self, keyword_messages, all_variable_list, variable_data_dict, replaced_string):
        """
        Updates variable dict based on keyword messages
        :param keyword_messages: List of messages read
        :param all_variable_list: List of all variables
        :param variable_data_dict: variable dict to be updated with data read
        :param replaced_string: String to be replaced
        :return: variable_data_dict
        """
        for keyword_message in keyword_messages:
            variable_data_found = []
            match_found, total_matches = self._get_variable_mapping(
                replaced_string, keyword_message, variable_data_found)
            if match_found and total_matches == len(all_variable_list):
                variable_data_dict = dict(zip(all_variable_list, variable_data_found))
                break
        return variable_data_dict

    def _update_variables_dict_if_length_match(
            self, find_variables_in_string, variables_to_find, keyword_messages,
            variable_data_dict):
        """
        Updates variables data dict if find variables length is equal to variables to find
        :param find_variables_in_string: List of string variable names to find
        :param variables_to_find: Variables to find in list
        :param keyword_messages: List of messages read
        :param variable_data_dict: variable dict to be updated with data read
        :return:
        """
        if len(find_variables_in_string) == len(variables_to_find):
            replaced_string = self.variables["Arguments"].get("STRING", "")
            all_variable_list = []
            for variable_to_find in variables_to_find:
                all_variable_list.append(variable_to_find)
                replaced_string = replaced_string.replace(
                    variable_to_find, parse_variables.VARIABLE_REPLACEMENT)
            variable_data_dict = self._update_variable_dict_on_keyword_messages(
                keyword_messages, all_variable_list, variable_data_dict, replaced_string)

            if variable_data_dict:
                for robot_variable in self.variables["Arguments"].get("ROBOT", {}):
                    if robot_variable in variable_data_dict:
                        self.variables["Arguments"]["ROBOT"][robot_variable] = \
                            variable_data_dict[robot_variable]

    def _read_value_from_substrings(self, keyword_messages):
        """
        Reads value of variables from substrings containing variables. Matches scenario 4:
        4. If Argument has other string with it then read it in order of substring match.
        :param keyword_messages: Keyword messages logged for the keyword
        """
        for user_variable in self.variables["Arguments"].get("USER", {}):
            value = self._find_user_variable_value(user_variable, keyword_messages)
            self.variables["Arguments"]["USER"][user_variable] = value

        variables_to_find = self.variables["Arguments"].get("USER", {}).copy()
        variables_to_find.update(self.variables["Arguments"].get("ROBOT", {}))
        variable_data_dict = {}
        find_variables_in_string = [True for x in list(variables_to_find.keys())
                                    if x in self.variables["Arguments"].get("STRING", "")]
        self._update_variables_dict_if_length_match(find_variables_in_string, variables_to_find,
                                                    keyword_messages, variable_data_dict)


    @staticmethod
    def _get_variable_mapping(variable_replaced_string,
                              message, variable_list=None):
        """
        Looks up message string for equality. If equal subtracted variables then build
        the variable name value dictionary. Overall logic:
        :param variable_replaced_string: String with variable names replaced by _
        :param message: An internal message string read from step messages.
        :param variable_list: data found is built into this list for variable data
        :returns True if match is found and the total number of matches replaced
        """
        if variable_list is None:
            variable_list = []
        seq_matcher = SequenceMatcher(None, variable_replaced_string, message)
        match_found = True
        total_matches = 0
        variable_data_read = []
        for tag, i1, i2, j1, j2 in seq_matcher.get_opcodes():
            if tag not in ["equal", "replace"]:
                match_found = False
                break
            if tag == "replace":
                if variable_replaced_string[i1: i2] == parse_variables.VARIABLE_REPLACEMENT:
                    variable_data_read.append(message[j1: j2])
                    total_matches += 1
                else:
                    match_found = False
                    break
        if match_found:
            variable_list.extend(variable_data_read)
        return match_found, total_matches