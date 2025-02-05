*** Settings ***
Resource    ../Tests/Resource/Report_Generation.robot
#Suite Setup    Access to Maintained Workflow.System Logon
#Suite Teardown    Access to Maintained Workflow.System Logout
Test Tags    Report_Generation

*** Test Cases ***
Generate report
    Generate report