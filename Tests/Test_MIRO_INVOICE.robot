*** Settings ***
Resource    ../Tests/Resource/MIRO_INVOICE.robot
Suite Setup    MIRO_INVOICE.System Logon
# Suite Teardown    MIRO_INVOICE.System Logout
Test Tags    Miro_invoice_dc
*** Test Cases ***
MIRO_INVOICE
    MIRO_INVOICE