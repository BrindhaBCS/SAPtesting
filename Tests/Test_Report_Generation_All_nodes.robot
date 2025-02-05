*** Settings ***
Resource    ../Tests/Resource/Report_Generation_All_nodes.robot
#Suite Setup    Access to Maintained Workflow.System Logon
#Suite Teardown    Access to Maintained Workflow.System Logout
Test Tags    Report_Generation_All_nodes

*** Test Cases ***
Generate report All Nodes
    Generate report All Nodes