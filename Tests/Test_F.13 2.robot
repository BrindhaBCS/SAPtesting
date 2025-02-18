*** Settings ***
Resource    ../Tests/Resources/F.13.robot
Suite Setup    F.13.System Logon
Suite Teardown    F.13.System Logout
Test Tags    F.13


*** Test Cases ***
Execution
    F.13_tcode
