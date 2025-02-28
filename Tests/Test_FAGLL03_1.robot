*** Settings ***
Resource    ../Tests/Resource/FAGLL03_1.robot
Suite Setup    FAGLL03_1.System Logon
Suite Teardown    FAGLL03_1.System Logout
Test Tags    FAGLL03_1


*** Test Cases ***
Execution
    FAGLL03_1