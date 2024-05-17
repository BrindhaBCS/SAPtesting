
*** Settings ***
Resource    ../Tests/Resource/Spampatch.robot
Task Tags   spampatch
Suite Setup    Spampatch.System Logon
# Suite Teardown    Spampatch.System Logout
  
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
    Start Options
    Import Option
    # Confirm Queue




    




