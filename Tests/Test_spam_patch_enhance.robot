*** Settings ***
Resource    ../Tests/Resource/Spam_Patch_enhance.robot
Task Tags   spampatchenhance
  
*** Test Cases ***
Check RBT Logon  
    RBT Logon
 
Check_Spam_update
    Spam Transaction
    Certificate Verification
    Loading package
    Display/Define
    Spam software selection
    Important SAP note handling

# Import Queue
#     Importing queue from support package
#     Confirm Queue




    





