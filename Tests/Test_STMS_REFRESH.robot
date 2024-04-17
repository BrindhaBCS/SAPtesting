*** Settings ***
Resource    ../Tests/Resource/STMS_REFRESH.robot  
Suite Setup    STMS_REFRESH.System Logon
Suite Teardown    STMS_REFRESH.System Logout
Task Tags    STMS_REFRESH
 
 
*** Test Cases ***
STMS_T_CODE
    STMS_T_CODE