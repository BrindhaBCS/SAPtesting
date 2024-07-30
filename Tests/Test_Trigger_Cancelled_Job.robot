*** Settings ***
Resource    ../Tests/Resource/Trigger_Cancelled_Job.robot
Force Tags   TriggerJob
Suite Setup    Trigger_Cancelled_Job.System Logon
Suite Teardown    Trigger_Cancelled_Job.System Logout
 
*** Test Cases ***
Resheduling the cancelled job
    Trigger cancelled job