*** Settings ***
Resource    ../Tests/Resource/testtags.robot
Force Tags   testtags
# Test Setup    FB03.SAP logon
# Test Teardown    FB03.SAP Logout
 
*** Test Cases ***
Verifying Certificate
    [Tags]    SM02_T1
    [Setup]    System Logon 
    SM02
    [Teardown]    System Logout
Read excel and create invoice
    [Tags]    FB70_T2
    [Setup]    SAP logon
    FB70 Invoice entry
    [Teardown]    SAP Logout
Read excel and view invoice
    [Tags]    FB03_T3
    [Setup]    SAP logon
    FB03 display the invoice document
    [Teardown]    SAP Logout
