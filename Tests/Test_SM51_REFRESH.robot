*** Settings ***
Resource    ../Tests/Resource/SM51_REFRESH.robot   
Suite Setup    SM51_REFRESH.System Logon
Suite Teardown    SM51_REFRESH.System Logout
Task Tags    SM51_REFRESH
 
 
*** Test Cases ***
SM51_T_CODE
    SM51_T_CODE