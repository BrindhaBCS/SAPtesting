*** Settings ***
Resource    ../Tests/Resource/MSO_Billing_Invoice.robot
Test Tags    MSO_Billing_Invoice
Suite Setup    MSO_Billing_Invoice.System Logon
Suite Teardown    MSO_Billing_Invoice.System Logout
  
*** Test Cases ***
MSO_Billing_Invoice
    MSO_Billing_Invoice
