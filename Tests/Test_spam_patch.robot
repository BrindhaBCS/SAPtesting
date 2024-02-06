*** Settings ***
Resource    ../Tests/Resource/Spam_Patch.robot
Resource    ../Tests/Resource/Common_Function.robot
Task Tags   spampatch
Suite Setup    Common_Function.System Logon
Suite Teardown    Common_Function.System Logout
 
*** Test Cases *** 
Check_Spam_update
    Spam Transaction
    Certificate Verification
    Loading package
    Display/Define
    Spam Component selection
    Spam Patch selection
    Important SAP note handling

Import Queue
    Importing queue from support package
    Confirm Queue




    





