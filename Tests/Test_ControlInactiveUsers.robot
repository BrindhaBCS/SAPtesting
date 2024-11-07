*** Settings ***
Resource    ../Tests/Resource/ControlInactive Users.robot
Test Tags    CIU
Suite Setup    ControlInactive Users.System Logon
Suite Teardown    ControlInactive Users.System Logout

*** Test Cases ***
SE16
    SE16
    Generate report