*** Settings ***
Resource    ../Tests/Resource/ST03N_retentionTime_REFRESH.robot
Suite Setup    ST03N_retentionTime_REFRESH.System Logon
Suite Teardown    ST03N_retentionTime_REFRESH.System Logout
Task Tags    ST03N_REFRESH
 
 
*** Test Cases ***
scenario-retentionTime
    scenario-retentionTime