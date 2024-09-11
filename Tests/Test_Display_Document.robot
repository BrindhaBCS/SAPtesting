*** Settings ***
Resource    ../Tests/Resource/Display_Document.robot
Force Tags   Vendor_doc
Suite Setup    Display_Document.SAP logon
Suite Teardown    Display_Document.SAP Logout
 
*** Test Cases ***
Interlinked transactions for Invoice
    FB03 display the invoice document
