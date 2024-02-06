"""
Support methods for user arguments
"""
import os
import sys


"""
Supports user input processing
"""
def process_data_file(args):
    """
    Reads data in the data file and updates argument values. Data from this
    file overrides what is defined by user in command line
    :param args: Arguments containing value for data file
    :return: Updated args values
    """
    with open(args.datafile, "r") as file_object:
        file_lines = file_object.readlines()
    for line in file_lines:
        line = line.strip()
        if not line or "=" not in line:
            # Blank line or information line
            continue
        key, value = line.split("=")
        exec("args." + key.strip() + " = '" + value.strip() + "'")
    args.dryrun = _update_boolean_variable_values(args.dryrun)
    args.JSON_FORMAT = _update_boolean_variable_values(args.JSON_FORMAT)
    args.no_jira_upload = _update_boolean_variable_values(args.no_jira_upload)
    return args

def _update_boolean_variable_values(variable):
    """
    Updates the boolean variable value after reading from data file to ensure boolean
    False remain as False
    :param variable: Variable to update
    :return: Actual value for boolean variable
    """
    actual_value = True
    if str(variable).lower() == "false" or not variable:
        actual_value = False
    return actual_value