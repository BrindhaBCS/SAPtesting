*** Settings ***
Resource    ../Tests/Resource/Spam_Update.robot
Resource    ../Tests/Resource/Common_Function.robot
Task Tags   spamupdate
Suite Setup    Common_Function.System Logon
Suite Teardown    Common_Function.System Logout
 
 
*** Test Cases *** 
Check_Spam_update
    Spam Transaction
    Certificate Verification
    Loading package
    Import Spam/Saint update
    
    





