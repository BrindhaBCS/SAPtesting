*** Settings ***
Resource    ../Tests/Resource/Spam_Patch_enhance.robot
Resource    ../Tests/Resource/Common_Function.robot
Task Tags   spampatchenhance
Suite Setup    Common_Function.System Logon
Suite Teardown    Common_Function.System Logout
  
*** Test Cases ***
# Check RBT Logon  
#     RBT Logon
 
Check_Spam_update
    Spam Transaction
    Certificate Verification
    Loading package
    Display/Define
    Spam software selection
    Important SAP note handling

Import Queue
    Importing queue from support package
    Confirm Queue




    





