*** Settings ***
Resource    ../Tests/Resource/sales_order_creation.robot
Suite Setup    sales_order_creation.System Logon
Suite Teardown    sales_order_creation.System Logout
Test Tags    salesorder


*** Test Cases ***
SLAES_ORDER_CREATION
    SLAES_ORDER_CREATION