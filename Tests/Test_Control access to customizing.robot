*** Settings ***
Resource    ../Tests/Resource/Control access to customizing.robot
Suite Setup    Control access to customizing.System Logon
Suite Teardown    Control access to customizing.System Logout
Test Tags    Control_access_to_customizing

*** Test Cases ***
Control access to customizing
    Control access to customizing
Generate report
    Generate report