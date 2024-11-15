*** Settings ***
Resource    ../Tests/Resource/MIRO_INVOICE_POST_PAYMENTS.robot
Suite Setup    MIRO_INVOICE_POST_PAYMENTS.System Logon
Suite Teardown    MIRO_INVOICE_POST_PAYMENTS.System Logout
Test Tags    MIRO_INVOICE_POST_PAYMENTS_dc
*** Test Cases ***
MIRO_INVOICE_POST_PAYMENTS
    MIRO_INVOICE_POST_PAYMENTS