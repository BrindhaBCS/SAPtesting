"""
Contains functionality to support the creation of models
"""


def convert_to_list(value, default_value=""):
    """
    For value not in list type it converts into list format
    :param value: Value to be returned converted to list type
    :param default_value: Value to be added to the list regardless
    :return: list format for value
    """
    if isinstance(value, list):
        if len(value) == 1 and not value[0]:
            value = []
    elif isinstance(value, str):
        if not value:
            value = []
        else:
            if "," in value:
                value = [x.strip() for x in value.split(",")]
            else:
                value = [value]
    if value == [","]:
        value = []
    if default_value:
        value.append(default_value)
    return list(set(value))


def convert_list_to_string(list_object):
    """
    Converts a list to of type string
    :param list_object: List containing strings
    :return: comma separated string of list values
    """
    if list_object:
        list_object = get_comma_separated_variable_list(list_object)
    else:
        list_object = ""
    return list_object


def read_variable_string(variable_string):
    """
    Reads for variable values in the format key:value, pairs
    :param variable_string:
    :return: Variables dict
    """
    variables = {}
    for variable_pair in variable_string.split(","):
        if ":" in variable_pair:
            key, value = variable_pair.split(":", 1)
            variables[key.strip()] = value.strip()
    return variables


def get_comma_separated_variable_list(value):
    """
    String with values separated by comma are built into a string format
    :param value: String with comma separated values
    :return: List of values
    """
    values = [x.strip() for x in value.split(",")]
    if values == [""]:
        values = []
    return values


def check_data_driven_from_string(data_driven_string):
    """
    Checks from the string parameter if the test is data driven
    :param data_driven_string: String with value True/true to point to data driven test
    :return: True if string points to data driven test type
    """
    data_driven_check = False
    if str(data_driven_string).lower().strip() == "true":
        data_driven_check = True
    return data_driven_check


def convert_list_to_line_separated(list_value):
    """
    Converts a list of strings to line separated string
    :param list_value: List of strings
    :return: New line separated list values
    """
    value = list_value
    if isinstance(list_value, list) and list_value:
        value = "\n".join(list_value)
    return value
