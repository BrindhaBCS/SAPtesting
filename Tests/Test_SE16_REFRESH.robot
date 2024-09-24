*** Settings ***
Resource    ../Tests/Resource/SE16_REFRESH.robot   
Suite Setup    SE16_REFRESH.System Logon
Suite Teardown    SE16_REFRESH.System Logout
Task Tags    SE16_REFRESH
 
 
*** Test Cases ***
SE16_T_CODE
    SE16_T_CODE