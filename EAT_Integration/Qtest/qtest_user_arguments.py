"""
Handles user defined arguments passed from command line.
"""
import argparse
import os
import sys
from Support import user_argument_support

class UserArguments:
    """
    Handles creation of parser and parsing of user input for qTest
    """
    def __init__(self):
        "Sets up default values for the parser"
        self.qtest_default_url = "https://manager.qtest.jnj.com"
        self.eat_api_url = "https://appdevtools.jnj.com"
        self.parser = self._create_user_arguments()

    def _create_user_arguments(self):
        parser = argparse.ArgumentParser("Parser for qTest tests/results uploader.")

        # Common args
        parser.add_argument("-ct_json", "--CREATE_TEST_JSON_FORMAT", action='store_true',
                            help="If specified then it creates json format "
                                 "from Robot Output.xml file for test creation.")
        parser.add_argument("-res_json", "--RESULT_UPLOAD_JSON_FORMAT", action='store_true',
                            help="If specified then it creates json format "
                                 "from Robot Output.xml file for result upload.")
        parser.add_argument("-qtoken", "--qtest_token",
                            help="qTest bearer token (obtained from from qTest dashboard)",
                            default="")
        parser.add_argument("-eat_url", "--eat_url",
                            help="EAT API URL to connect to for execution.",
                            default=self.eat_api_url)
        parser.add_argument("-qurl", "--qtest_url",
                            help="qTest URL to connect to for execution.",
                            default=self.qtest_default_url)
        parser.add_argument("-r", "--results_file",
                            help="The Robot Framework result Output.xml file", default="")
        parser.add_argument("-dr", "--dryrun", action='store_true',
                            help="Simulates test upload without impact on qTest")
        parser.add_argument("-qpid", "--qtest_project_id",
                            help="The qtest id for the project", default="")
        parser.add_argument("-qfid", "--qtest_folder_id",
                            help="The qtest folder id - if not specified creates in the Automation Test Cases folder", default="")
        parser.add_argument("-qpar", "--qtest_parent_id",
                            help="The qtest id of the test-suite, test-cycle or release parent type of the test run", default="")
        parser.add_argument("-qpart", "--qtest_parent_type",
                            help="Parent type of test run - 'test-suite', 'test-cycle' or 'release'", 
                            choices=["test-suite", "test-cycle", "release"], default="")
        parser.add_argument("-stop_approval", "--stop_approval_on_test_creation", action='store_true',
                            help="Will automatically set created test to not completed")
        
        # Create/Update test args
        parser.add_argument("-qassign", "--qtest_assignee",
                            help="Username of assignee (not WWID)", default="")
        parser.add_argument("-qlev", "--test_level",
                            help="Type of test being executed e.g. UAT, ST", default="ST")
        parser.add_argument("-qpres", "--qtest_prerequisites",
                            help="Test prerequisites", default="")

        # Create/Update test run args
        parser.add_argument("-qrunid", "--qtest_run_id",
                            help="If the value specified then the result uploaded to"
                            " this test run id rather than creating a new one.",
                            default="")
        parser.add_argument("-qnote", "--qtest_run_note",
                            help="Notes or references",
                            default="")

        #Extras
        parser.add_argument("-tzd", "--time_difference_from_gmt",
                            help="Timezone difference from GMT e.g. +0530 for IST,"
                            " -0400 for EST. If not given the system checks time "
                            "difference from local machine to GMT", default="")
        parser.add_argument("-df", "--datafile",
                            help="Data file which contains information for earlier variables.",
                            default="")
        parser.add_argument("-dd", "--data_driven",  action='store_true',
                            help="If specified then it assumes the xml file contains one or more executions of a datadriven template test.")
        parser.add_argument("-tmpl", "--template", action='store_true',
                            help="Force uploader to treat tests as template tests (ignore higher level template keyword)")
        
        # Json parameters
        json_params = ["-ct_json", "--CREATE_TEST_JSON_FORMAT", "-res_json",
                       "--RESULT_UPLOAD_JSON_FORMAT", "-h", "--help"]
        if any([i for i in json_params if i in sys.argv[1:]]):
            parser = self._add_json_creator_argument(parser)
        return parser

    @staticmethod
    def _add_json_creator_argument(parser):
        """
        Adds json creation argument arguments to parser
        :param parser: Parser to add options for json creation
        :return: Updated parser object
        """
        parser.add_argument("-qof", "--json_output_file",
                            help="Json output file path to be created from robot results.",
                            default="Json_Results.json")
        parser.add_argument("-qpr", "--qtest_overall_priority",
                            help="Priority to be applied across all tests in Json create test.",
                            default="Medium")
        parser.add_argument("-qobs", "--qtest_obsoleted",
                            help="Whether test is obsolete.",
                            default="No")
        parser.add_argument("-inc_qobs", "--include_qtest_obsoleted", action='store_true',
                            help="Will include mandatory field in additionalFields")
        return parser

    def parse_arguments(self, user_arguments=None):
        """
        Parses arguments specified by the user for qTest uploader
        :param user_arguments: List of user arguments.
        :return: values read from parser
        """
        if user_arguments is None:
            user_arguments = sys.argv[1:]
        args = self.parser.parse_args(user_arguments)
        if args.datafile and os.path.exists(args.datafile):
            args = user_argument_support.ArgSupport._process_data_file(args)
        return args