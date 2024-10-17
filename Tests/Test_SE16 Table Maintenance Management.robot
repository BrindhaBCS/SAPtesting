*** Settings ***
Resource    ../Tests/Resource/SE16 Table Maintenance Management.robot
Suite Setup    SE16 Table Maintenance Management.System Logon
Suite Teardown   SE16 Table Maintenance Management.System Logout
Test Tags    SE16_Table_Maintenance_Management

*** Test Cases ***
SE16 Table Maintenance Management
    SE16 Table Maintenance Management
Generate report
    Generate report