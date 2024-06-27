*** Settings ***
Resource    ../Tests/Resource/SM02.robot
Resource    ../Tests/Resource/FB03.robot
Resource    ../Tests/Resource/FB70.robot
Force Tags   testtags
# Test Setup    FB03.SAP logon
# Test Teardown    FB03.SAP Logout
 
*** Test Cases ***
Verifying Certificate
    [Tags]    SM02_T1
    [Setup]    SM02.System Logon 
    SM02
    [Teardown]    SM02.System Logout
Read excel and create invoice
    [Tags]    FB70_T2
    [Setup]    FB70.SAP logon
    FB70 Invoice entry
    [Teardown]    FB70.SAP Logout
Read excel and view invoice
    [Tags]    FB03_T3
    [Setup]    FB03.SAP logon
    FB03 display the invoice document
    [Teardown]    FB03.SAP Logout