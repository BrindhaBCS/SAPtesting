*** Settings ***
Resource    ../Tests/Resource/AL11_REFRESH.robot   
Suite Setup    AL11_REFRESH.System Logon
Suite Teardown    AL11_REFRESH.System Logout
Task Tags    AL11_REFRESH
 
 
*** Test Cases ***
AL11_T_CODE
    AL11_T_CODE