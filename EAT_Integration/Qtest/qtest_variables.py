"""
Contains hard coded constant definition for qTest uploader functionality
"""

# Classifications
TEST_NOT_FOUND = "Not Found"
TEST_NAME_FOUND = "Test Name Found"
TEST_MATCHES_EXACTLY = "Exact Test Found"

# Jira Issue types
TEST_ISSUE_TYPE = "Test"
TEST_TYPE_MAPPING = {"value": "Manual", "id": "12900"}
TEST_COMPLETED_STATUS = "Completed"

# Dependencies used for executing tests
DEPENDENCIES = "dependencies"

# Test upload constant strings
SUMMARY = "Execution of automated tests in qTest Upload."
EXECUTION_DESCRIPTION = "This execution is automatically created when " +\
                        "importing execution results from an external source. Updated: "

# qTest upload api variables
QTEST_EXECUTION_IMPORT_API = "/api/v3/"
API_HEADERS = {"Content-Type": "application/json"}
QTEST_API_LOGIN_URL = "/api/login"
QTEST_API_CREATE_TEST = "/api/v1/qtest/createTest" 
QTEST_API_CREATE_TEST_EXECUTION = "/api/v1/qtest/createTestExecution"
QTEST_API_UPDATE_TEST = "/api/v1/qtest/updateTest" 
QTEST_SEARCH_ISSUE = "/api/v3/projects/"
USERNAME_KEY = "username"
PASSWORD_KEY = "password"

# Report version generated for PDF report
REPORT_VERSION = "1.0"
REPORT_OUTPUT_FOLDER = "temp_qtest_reports"

# Test Execution date support
TEST_EXECUTION_FIRST_START = "first_start"
TEST_EXECUTION_LAST_END = "last_end"

# Test Creation fields
TEST_ACTION = "Action"
TEST_DATA = "Data"
TEST_EXPECTED_RESULT = "Expected Result"

# Test Step Creation fields
TEST_STEP_NUMBER = "stepNumber"
TEST_STEP_DESCRIPTION = "stepDescription"
TEST_STEP_EXPECTED = "stepExpected"
TEST_STEP_DATA = "stepData"
TEST_STEP_DATA_STRIVEN = "stepDataDriven"

# JSON Schema variables
ADD_PDF_REPORT = "addtestreportpdf"
ADD_PDF_REPORT_DEFAULT = True