*** Settings ***
Resource    ../Tests/Resource/Access to Maintained Workflow.robot
Suite Setup    Access to Maintained Workflow.System Logon
Suite Teardown    Access to Maintained Workflow.System Logout
Test Tags    Access_to_Maintained_Workflow

*** Test Cases ***
Access to Maintained Workflow
    Access to Maintained Workflow
Generate report
    Generate report