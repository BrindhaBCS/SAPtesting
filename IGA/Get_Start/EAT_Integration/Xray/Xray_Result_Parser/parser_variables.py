"""
Adds constants to deal with json parser information.
"""
import ntpath
import os


def get_version():
    """
    Fetches version number for the release from file __version__ in the root of the project
    :return: Version of the project
    """
    dir_path = os.path.dirname(os.path.realpath(__file__))
    level = 4
    version_number = "1.5"
    for _ in range(level):
        dir_path = ntpath.dirname(dir_path)
    file_path = os.sep.join([dir_path, "__version__"])
    if os.path.exists(file_path):
        version_number = open(file_path, "r").read().strip()
    return version_number


# Json Creator constants
CREATE_TEST = "Create_Test"
ADD_RESULT = "Add_Result"

# JSON Schema variables
ADD_PDF_REPORT = "addtestreportpdf"
ADD_PDF_REPORT_DEFAULT = True
# Suite fields
PROJECT_FIELD = "project"
SUITE_FIELD = "suite"
AUTOMATION_TEST_TYPE = "Manual"
AUTOMATION_TEST_PRIORITY = "Medium"
JIRA_ID_FIELD = "jiraIds"
TEST_TYPE = "testType"
TEST_LABELS = "testLabels"
TEST_EXECUTION_LABELS = "labels"
TEST_PRIORITY = "testPriority"
TEST_AFFECTS_VERSION = "testAffectsVersions"
TEST_EXECUTION_AFFECTS_VERSION = "affectsVersion"
TEST_FIX_VERSION = "testFixVersions"
TEST_EXECUTION_FIX_VERSION = "fixVersion"
TEST_COMPONENTS = "testComponents"
TEST_EXECUTION_COMPONENTS = "components"
TEST_APPROVAL_CATEGORY = "testApprovalCategory"
TEST_ASSIGNEE = "testAssignee"
TEST_REPORTER = "testReporter"
TEST_COMMENT = "testComment"
TEST_ENVIRONMENT_INFO = "testEnvironmentInformation"
TEST_CATEGORY = "testTestCategory"
TEST_EXECUTION_CATEGORY = "testCategory"
TEST_SET_FOR_TESTS = "testSet"
TEST_PLAN_FOR_TESTS = "testPlan"
TEST_COMM = "comment"
NAME = "name"
# Test fields
TESTS_SECTION = "tests"
TESTS_NAME = "testName"
TEST_KEY = "testKey"
TEST_START = "start"
TEST_FINISH = "finish"
TEST_STATUS = "status"
TESTS_DOCUMENTATION = "testDocumentation"
TEST_DEFECTS = "defects"
TEST_EXAMPLES = "examples"
# Step fields
STEPS_SECTION = "steps"
STEPS_NUMBER = "stepNumber"
STEPS_DESCRIPTION = "stepDescription"
STEPS_EXPECTED = "stepExpected"
STEPS_VARIABLES = "stepData"
STEPS_STATUS = "status"
STEPS_START = "start"
STEPS_FINISH = "finish"
STEPS_EVIDENCES = "evidences"
STEPS_ACTUAL_RESULT = "actualResult"
STEPS_ACTUAL_RESULT_DEFAULT = "Actual result on Test Step Result"
STEPS_COMMENT = ""
STEPS_COMMENT_DEFAULT = ""
STEPS_ATTACHMENT_DATA = "data"
STEPS_ATTACHMENT_CONTENT_TYPE = "contentType"
STEPS_ATTACHMENT_FILENAME = "filename"
STEP_ATTACHMENT = "stepAttachment"

# Execution result fields
SE_INFO = "info"
SE_SUMMARY = "summary"
SE_VERSION = "version"
version = get_version()
SE_SUMMARY_DEFAULT = "Execution of automated tests for release v" + version
SE_DESCRIPTION = "description"
SE_DESCRIPTION_DEFAULT = "This execution is automatically created when importing" +\
                         " execution results from an external source"
SE_STATUS_DEFAULT = "PASS"
SE_STATUS_FAIL = "FAIL"
SE_TEST_TYPE_DEFAULT = "System"
SE_START_DATE = "startDate"
SE_FINISH_DATE = "finishDate"
SE_PROJECT_KEY_FIELD = "projectKey"
SE_START_DEFAULT = 1469756963000
SE_COMMENT_DEFAULT = ""
SE_REVISION = "revision"
SE_USER = "user"
SE_TEST_ENVIRONMENT = "testEnvironments"
SE_TEST_ENVIRONMENT_DEFAULT = ["N/A"]
SE_OS = "os"
import platform
SE_OS_NAME = platform.platform()
SE_PLATFORM = "platform"
SE_BROWSER_NAME = "browsername"
SE_BROWSER_NAME_DEFAULT = "Chrome"
SE_BROWSER_VERSION = "browserversion"
SE_BROWSER_DRIVER_VERSION = "browserdriverversion"

JIRA_SEARCH_ISSUE = "/rest/api/2/search?"



