*** Settings ***
Resource    ../Tests/Resource/MSO_Billing_Invoice.robot
Test Tags    MSO_Billing_Invoice
# Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
System Logon
    System Logon
MSO_Billing_Invoice
    MSO_Billing_Invoice
# System Logout
#     System Logout