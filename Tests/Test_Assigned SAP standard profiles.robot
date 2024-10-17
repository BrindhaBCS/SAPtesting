*** Settings ***
Resource    ../Tests/Resource/Assigned SAP standard profiles.robot
Suite Setup    Assigned SAP standard profiles.System Logon
Suite Teardown   Assigned SAP standard profiles.System Logout
Test Tags    Assigned_SAP_standard_profiles

*** Test Cases ***
Assigned SAP standard profiles
    Assigned SAP standard profiles
Generate report
    Generate report