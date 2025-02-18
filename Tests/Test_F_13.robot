*** Settings ***
Resource    ../Tests/Resource/F_13.robot
Suite Setup    F_13.System Logon
Suite Teardown    F_13.System Logout
Test Tags    F_13


*** Test Cases ***
Execution
    F.13_tcode
