*** Settings ***
Resource    ../Tests/Resource/Control mandant changes.robot
Suite Setup    Control mandant changes.System Logon
Suite Teardown    Control mandant changes.System Logout
Test Tags    Control_mandant_changes

*** Test Cases ***
Control mandant changes
    Control mandant changes
Generate report
    Generate report
    