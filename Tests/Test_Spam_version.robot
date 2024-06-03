
*** Settings ***
Resource    ../Tests/Resource/Spam_version.robot
Task Tags   spamversion
Suite Setup    Spam_version.System Logon
Suite Teardown    Spam_version.System Logout
  
*** Test Cases ***

Check_Spam_update
    Spam Transaction
    Certificate Verification
    Version check
    Loading package
    Display/Define
    Spam Component selection
    Spam Patch selection
    Important SAP note handling

Import Queue
    Importing queue from support package
    Start Options
    Import Option
    Confirm Queue
    Version check post upgrade




    




