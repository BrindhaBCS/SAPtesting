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


# JSON Schema variables
ADD_PDF_REPORT = "addtestreportpdf"
ADD_PDF_REPORT_DEFAULT = True

# Common fields
PROJECT_FIELD = "project"
FOLDER_FIELD = "folder"
AUTOMATION_CONTENT = "automationContent"

# Test fields only
MOVE_TO_COMPLETE = "moveToComplete"
UPDATE_TEST_ID = "testId"
TEST_ACTION = "action"

# Test and test execution fields
TEST_NAME = "testName"
TEST_ID = "testID"
TEST_ASSIGNEE = "testAssignee"
TEST_DESCRIPTION = "testDescription"
TEST_TYPE = "testType"
TEST_LEVEL = "testLevel"
PREREQUISITES = "preRequisites"
TEST_ATTACHMENTS = "attachments"
TEST_ATTACHMENT_DATA = "data"
TEST_ATTACHMENT_CONTENT_TYPE = "content_type"
TEST_ATTACHMENT_FILENAME = "name"
TEST_ADDITIONAL_FIELDS = "additionalFields"
TEST_RUN_ID = "testRunId"
TEST_RUN_ACTION = "action"
TEST_RUN_EXECUTION_LOG = "name"
TEST_RUN_PARENT = "parent"
TEST_RUN_PARENT_TYPE = "parentType"
TEST_START = "start"
TEST_FINISH = "finish"
TEST_STATUS = "status"
TEST_EXECUTION_NOTE = "executionNote"


# Step fields
STEPS_SECTION = "steps"
STEP_DESCRIPTION = "stepDescription"
STEP_EXPECTED_RESULT = "stepExpectedResult"
STEPS_RESULTS_SECTION = "stepLogs"
STEP_ORDER = "stepOrder"
STEP_ACTUAL_RESULT = "stepActualResult"
STEP_STATUS = "stepStatus"
STEP_START = "start"
STEP_FINISH = "finish"
STEP_ATTACHMENT = "attachments"
STEP_ATTACHMENT_DATA = "data"
STEP_ATTACHMENT_CONTENT_TYPE = "content_type"
STEP_ATTACHMENT_FILENAME = "name"

# Execution result fields
SE_INFO = "info"
SE_SUMMARY = "summary"
SE_VERSION = "version"
version = get_version()
SE_SUMMARY_DEFAULT = "Execution of automated tests for release v" + version
SE_DESCRIPTION = "description"
SE_DESCRIPTION_DEFAULT = "This execution is automatically created when importing" +\
                         " execution results from an external source"
SE_STATUS_DEFAULT = "Pass"
SE_STATUS_FAIL = "Fail"
SE_TEST_TYPE_DEFAULT = "System"
SE_START_DATE = "startDate"
SE_FINISH_DATE = "finishDate"
SE_PROJECT_KEY_FIELD = "projectKey"
SE_START_DEFAULT = 1469756963000
SE_COMMENT_DEFAULT = "" #  Comment on Test
SE_REVISION = "revision"
SE_USER = "user"
SE_TEST_ENVIRONMENT = "testEnvironments"
SE_TEST_ENVIRONMENT_DEFAULT = ["N/A"]
SE_OS = "os"
try:
    SE_OS_NAME = os.uname
except AttributeError:
    import platform
    SE_OS_NAME = platform.platform()
SE_PLATFORM = "platform"
SE_BROWSER_NAME = "browsername"
SE_BROWSER_NAME_DEFAULT = "Chrome"
SE_BROWSER_VERSION = "browserversion"
SE_BROWSER_DRIVER_VERSION = "browserdriverversion"

QTEST_API_URL = "https://dev-manager.qtest.jnj.com"
QTEST_SEARCH_ISSUE = "/api/v3/projects/"
QTEST_TEST_OPEN_STATUS = "0.1"
