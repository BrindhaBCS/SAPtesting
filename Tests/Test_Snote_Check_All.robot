*** Settings ***
Resource    ../Tests/Resource/Snote_Check_All.robot
Test Tags    Snote_check_All
Suite Setup    Snote_Check_All.System Logon
Suite Teardown    Snote_Check_All.System Logout
*** Test Cases ***
SNOTE
    SNOTE