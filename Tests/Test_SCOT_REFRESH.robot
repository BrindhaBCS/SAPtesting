*** Settings ***
Resource    ../Tests/Resource/SCOT_REFRESH.robot   
Suite Setup    SCOT_REFRESH.System Logon
Suite Teardown    SCOT_REFRESH.System Logout
Task Tags    SCOT_REFRESH
 
 
*** Test Cases ***
SCOT_T_CODE
    SCOT_T_CODE