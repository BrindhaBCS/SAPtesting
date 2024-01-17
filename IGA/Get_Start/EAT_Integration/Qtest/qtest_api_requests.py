"""
Handles qTest api requests.
"""
import requests
import Qtest.qtest_variables as variables
from Support import logger_handler
from Support.date_and_time_support import DateTimeSupport


class QtestApiRequests:
    """
    Handles qTest API request processing. Any REST API calls are made through this.
    """
    def __init__(self, test, jira_test, args):
        """
        Initializes the class with test variables containing information to build and process
        test data payload
        :param test: Test to be uploaded for result
        :param jira_test: Jira object of test being uploaded
        :param args: User defined arguments
        """
        self.logger = logger_handler.setup()
        self.test = test
        self.jira_test = jira_test
        self.args = args
        self.datetime_support = DateTimeSupport(self.args)  

    def _request_query_qtest(self, request_type, query, token, **kwargs):
        """
        Executes a REST API call based on type, query and request arguments
        - used with generic API to check if test already exists
        :param request_type: Type of request e.g. POST or GET
        :param query: The request url to access
        :param token: Token required for authentication
        :param kwargs: query argument data to be passed as payload
        :return: False if the query operation failed or the text of successful execution
        """
        request_object = None
        headers = variables.API_HEADERS
        headers.update({"Authorization" : "Bearer " + token})
        if request_type == "POST":
            request_object = requests.post(query, headers=headers, **kwargs)
        elif request_type == "GET" and token:
            request_object = requests.get(query, headers=headers, **kwargs)
        result = False
        if request_object and request_object.status_code == 200:
            result = request_object.text
        else:
            self.logger.info(request_object.status_code)
            self.logger.info(request_object.text)
            self.logger.info(request_object.reason)
        return result, request_object.status_code

    def _request_query(self, request_type, query, token, **kwargs):
        """
        Executes a REST API call based on type, query and request arguments
        - used with EAT APi for test upload
        :param request_type: Type of request e.g. POST or GET
        :param query: The request url to access
        :param token: Token required for authentication
        :param kwargs: query argument data to be passed as payload
        :return: False if the query operation failed or the text of successful execution
        """
        request_object = None
        headers = variables.API_HEADERS
        headers.update({"token" : token})
        if request_type == "POST":
            request_object = requests.post(query, headers=headers, **kwargs)
        elif request_type == "GET" and token:
            request_object = requests.get(query, headers=headers, **kwargs)
        result = False
        if request_object and request_object.status_code == 200:
            result = request_object.text
        else:
            self.logger.info(request_object.status_code)
            self.logger.info(request_object.text)
            self.logger.info(request_object.reason)
        return result, request_object.status_code