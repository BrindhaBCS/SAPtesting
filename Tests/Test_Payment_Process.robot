*** Settings ***
Resource    ../Tests/Resource/Payment_Process.robot
Suite Setup    Payment_Process.System Logon
Suite Teardown    Payment_Process.System Logout
Task Tags    Payment_process
 
 
*** Test Cases ***
Payment process for the Vendor Outstanding Due
    Vendor payments