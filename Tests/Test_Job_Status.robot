*** Settings ***
Resource    ../Tests/Resource/Job_Status.robot
Force Tags   jobstatus
Suite Setup    Job_Status.System Logon
Suite Teardown    Job_Status.System Logout
 
*** Test Cases ***
Providing Job Status for a user
    Display Job Status