*** Settings ***
Resource    ../Tests/Resource/Invoice_Creation.robot
Task Tags   invoice
Suite Setup    Invoice_Creation.SAP logon
Suite Teardown    Invoice_Creation.SAP Logout

*** Test Cases ***
Interlinked transactions for Invoice
    FB70 Invoice entry
    FB03 display the invoice document
    Transaction code FB03