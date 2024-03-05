*** Settings ***
Resource    ../Tests/Resource/RZ10_REFRESH.robot   
Suite Setup    RZ10_REFRESH.System Logon
Suite Teardown    RZ10_REFRESH.System Logout
Task Tags    RZ10_REFRESH
 
 
*** Test Cases ***
RZ10_T_CODE
    RZ10_T_CODE
