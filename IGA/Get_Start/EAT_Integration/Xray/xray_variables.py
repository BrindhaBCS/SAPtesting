"""
Contains hard coded constant definition for XRay uploader functionality
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

# XRay upload constant strings
SUMMARY = "Execution of automated tests in XRay Upload."
EXECUTION_DESCRIPTION = "This execution is automatically created when " +\
                        "importing execution results from an external source. Updated: "

# XRay upload api variables
XRAY_EXECUTION_IMPORT_API = "/rest/raven/1.0/import/execution/"
API_HEADERS = {"Content-Type": "application/json"}
XRAY_API_LOGIN_URL = "/api/login"
XRAY_API_CREATE_TEST = "/api/v1/jiraxray/createTest" 
XRAY_API_CREATE_TEST_EXECUTION = "/api/v1/jiraxray/createTestExecution"
XRAY_API_UPDATE_TEST = "/api/v1/jiraxray/updateTest" 
JIRA_SEARCH_ISSUE = "/rest/api/2/search?"
USERNAME_KEY = "username"
PASSWORD_KEY = "password"

# Report version generated for PDF report
REPORT_VERSION = "1.0"
REPORT_OUTPUT_FOLDER = "temp_xray_reports"

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