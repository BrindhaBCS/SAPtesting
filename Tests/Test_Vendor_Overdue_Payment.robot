*** Settings ***
Resource    ../Tests/Resource/Vendor_Overdue_Payment.robot
Force Tags   vendor_due
Suite Setup    Vendor_Overdue_Payment.System Logon
Suite Teardown    Vendor_Overdue_Payment.System Logout
 
*** Test Cases ***
Getting the pending payments list for Vendor
    pending payments