*** Settings ***
Resource    ../Tests/Resource/FB70.robot
Task Tags   FB70
Suite Setup    FB70.SAP logon
Suite Teardown    FB70.SAP Logout

*** Test Cases ***
Interlinked transactions for Invoice
    FB70 Invoice entry