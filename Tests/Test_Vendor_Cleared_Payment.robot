*** Settings ***
Resource    ../Tests/Resource/Vendor_Cleared_Payment.robot
Force Tags   cleared_pay
Suite Setup    Vendor_Cleared_Payment.System Logon
Suite Teardown    Vendor_Cleared_Payment.System Logout
 
*** Test Cases ***
Getting the pending payments list for Vendor
    Cleared Payments
