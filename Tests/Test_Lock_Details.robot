*** Settings ***
Resource    ../Tests/Resource/Lock_Details.robot
Force Tags   locks
Suite Setup    Lock_Details.System Logon
Suite Teardown    Lock_Details.System Logout
 
*** Test Cases ***
Provide Lock Details
    Display Lock Details