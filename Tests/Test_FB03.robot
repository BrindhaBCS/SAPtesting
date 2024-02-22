*** Settings ***
Resource    ../Tests/Resource/FB03.robot
Task Tags   FB03
Suite Setup    FB03.SAP logon
Suite Teardown    FB03.SAP Logout

*** Test Cases ***
Interlinked transactions for Invoice
    FB03 display the invoice document