*** Settings ***

Resource    ../Tests/Resource/Create_billing_documents.robot
Force Tags    Create_billing_documents
Suite Setup    Create_billing_documents.System Logon
Suite Teardown   Create_billing_documents.System Logout
  
*** Test Cases ***
Executing VF01
    Transaction VF01