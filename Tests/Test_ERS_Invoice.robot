*** Settings ***
Resource    ../Tests/Resource/ERS_Invoice.robot
Test Tags    ERS_Invoice
Suite Setup    ERS_Invoice.System Logon
Suite Teardown    ERS_Invoice.System Logout
  
*** Test Cases ***

ERS_Invoice
    ERS_Invoice