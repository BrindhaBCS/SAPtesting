*** Settings ***
Resource    ../Tests/Resource/Billing_documents_2.robot
Suite Setup    Billing_documents_2.System Logon
Suite Teardown    Billing_documents_2.System Logout
Test Tags    Billing_Document_2


*** Test Cases ***
Billing Documents_2 Not Posted to Accounting
    Billing Documents_2 Not Posted to Accounting