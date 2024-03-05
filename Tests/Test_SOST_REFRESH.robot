*** Settings ***
Resource    ../Tests/Resource/SOST_REFRESH.robot   
Suite Setup    SOST_REFRESH.System Logon
Suite Teardown    SOST_REFRESH.System Logout
Task Tags    SOST_REFRESH
 
 
*** Test Cases ***
SOST_T_CODE
    SOST_T_CODE