*** Settings ***
Resource    ../Tests/Resource/Snote_Check.robot
Test Tags    Snote_check_
Suite Setup    Snote_Check.System Logon
# Suite Teardown    Snote_Check.System Logout
*** Test Cases ***
SNOTE
    SNOTE