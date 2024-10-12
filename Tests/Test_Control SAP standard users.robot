*** Settings ***
Resource    ../Tests/Resource/Control SAP standard users.robot
Suite Setup    Control SAP standard users.System Logon
Suite Teardown    Control SAP standard users.System Logout
Test Tags    Control_SAP_standard_users

*** Test Cases ***
Control SAP standard users
    Control SAP standard users