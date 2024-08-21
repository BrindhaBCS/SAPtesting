*** Settings ***
Resource    ../Tests/Resource/Customer_Payment.robot
Suite Setup    Customer_Payment.System Logon
Suite Teardown    Customer_Payment.System Logout
Task Tags    customer_payments
 
 
*** Test Cases ***
Payment process for the outstanding due
    Customer payments