*** Settings ***
Resource    ../Tests/Resource/SA_Roles_Minimal.robot
Suite Setup    SA_Roles_Minimal.System Logon
Suite Teardown    SA_Roles_Minimal.System Logout 
Test Tags    SA_Roles_Minimal_sym

*** Test Cases ***
Roles_Minimal_test
    Roles_Minimal