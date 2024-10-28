*** Settings ***
Resource    ../Tests/Resource/ControlProhibitedPassword.robot
Test Tags    CPP
Suite Setup    ControlProhibitedPassword.System Logon
Suite Teardown    ControlProhibitedPassword.System Logout

*** Test Cases ***
SE16
    SE16