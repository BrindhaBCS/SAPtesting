*** Settings ***
Resource    ../Tests/Resource/SFILE.robot
Test Setup    SFILE.System Logon
Test Teardown    SFILE.System Logout
Test Tags    SFILE_ST
*** Test Cases ***
SFILE
    SFILE