*** Settings ***
Resource    ../Tests/Resource/SM49_REFRESH.robot
Suite Setup    SM49_REFRESH.System Logon
Suite Teardown    SM49_REFRESH.System Logout
Task Tags    SM49_REFRESH
 
 
*** Test Cases ***
SM49_T_CODE
    SM49_T_CODE