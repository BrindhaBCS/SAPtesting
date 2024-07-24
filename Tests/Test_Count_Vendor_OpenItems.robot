*** Settings ***
Resource    ../Tests/Resource/Count_Vendor_OpenItems.robot
Force Tags   count
Suite Setup    Count_Vendor_OpenItems.System Logon
Suite Teardown    Count_Vendor_OpenItems.System Logout
 
*** Test Cases ***
Getting the pending payments count for a specific customer code
    Vendor Open Items