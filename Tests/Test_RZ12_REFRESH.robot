*** Settings ***
Resource    ../Tests/Resource/RZ12_REFRESH.robot   
Suite Setup    RZ12_REFRESH.System Logon
Suite Teardown    RZ12_REFRESH.System Logout
Task Tags    RZ12_REFRESH
 
 
*** Test Cases ***
RZ12_T_CODE
    RZ12_T_CODE