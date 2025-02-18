*** Settings ***
Resource    ../Tests/Resource/FAGLL03.robot
Suite Setup    FAGLL03.System Logon
Suite Teardown    FAGLL03.System Logout
Test Tags    FAGLL03


*** Test Cases ***
Execution
    FAGLL03