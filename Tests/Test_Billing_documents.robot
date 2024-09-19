*** Settings ***
Resource    ../Tests/Resource/Billing_documents.robot
Suite Setup    Billing_documents.System Logon
Suite Teardown    Billing_documents.System Logout
Test Tags    Billing_Document


*** Test Cases ***
Billing Documents Not Posted to Accounting
    Billing Documents Not Posted to Accounting