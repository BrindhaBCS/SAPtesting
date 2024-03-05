*** Settings ***
Resource    ../Tests/Resource/RZ03_REFRESH.robot   
Suite Setup    RZ03_REFRESH.System Logon
Suite Teardown    RZ03_REFRESH.System Logout
Task Tags    RZ03_REFRESH
 
 
*** Test Cases ***
RZ03_T_CODE
    RZ03_T_CODE