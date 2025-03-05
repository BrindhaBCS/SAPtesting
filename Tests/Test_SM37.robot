*** Settings ***
Resource    ../Tests/Resource/SM37.robot
Suite Setup    SM37.System Logon
Suite Teardown    SM37.System Logout
Test Tags    SM37


*** Test Cases ***
Execution
    Verfy the background jobs