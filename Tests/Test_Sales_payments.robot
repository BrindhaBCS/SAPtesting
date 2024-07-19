*** Settings ***
Resource    ../Tests/Resource/Sales_payments.robot
Suite Setup    Sales_payments.System Logon
Suite Teardown    Sales_payments.System Logout
Task Tags    sales_payments
 
 
*** Test Cases ***
Getting the pending payments list
    pending payments