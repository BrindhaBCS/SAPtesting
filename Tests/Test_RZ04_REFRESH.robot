*** Settings ***
Resource    ../Tests/Resource/RZ04_REFRESH.robot   
Suite Setup    RZ04_REFRESH.System Logon
Suite Teardown    RZ04_REFRESH.System Logout
Task Tags    RZ04_REFRESH
 
 
*** Test Cases ***
RZ04_T_CODE
    RZ04_T_CODE