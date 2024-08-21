*** Settings ***
Resource    ../Tests/Resource/Cancelled_jobdetails.robot
Force Tags   Cancel_jobs
Suite Setup    Cancelled_jobdetails.System Logon
Suite Teardown    Cancelled_jobdetails.System Logout
 
*** Test Cases ***
Providing Cancelled Job details
    Display cancelled job Details