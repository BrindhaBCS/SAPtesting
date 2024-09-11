*** Settings ***
Resource    ../Tests/Resource/Finished_Job_Details.robot
Force Tags   FinishJob
Suite Setup    Finished_Job_Details.System Logon
Suite Teardown    Finished_Job_Details.System Logout
 
*** Test Cases ***
Providing finished job details
    Display cancelled job Details