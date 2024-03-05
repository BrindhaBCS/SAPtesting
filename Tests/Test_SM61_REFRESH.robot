*** Settings ***
Resource    ../Tests/Resource/SM61_REFRESH.robot   
Suite Setup    SM61_REFRESH.System Logon
Suite Teardown    SM61_REFRESH.System Logout
Task Tags    SM61_REFRESH
 
 
*** Test Cases ***
SM61_T_CODE
    SM61_T_CODE