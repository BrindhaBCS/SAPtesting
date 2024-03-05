*** Settings ***
Resource    ../Tests/Resource/RZ70_REFRESH.robot  
Suite Setup    RZ70_REFRESH.System Logon
Suite Teardown    RZ70_REFRESH.System Logout
Task Tags    RZ70_REFRESH
 
 
*** Test Cases ***
RZ70_T_CODE
    RZ70_T_CODE