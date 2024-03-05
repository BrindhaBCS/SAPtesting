*** Settings ***
Resource    ../Tests/Resource/SM69_REFRESH.robot   
Suite Setup    SM69_REFRESH.System Logon
Suite Teardown    SM69_REFRESH.System Logout
Task Tags    SM69_REFRESH
 
 
*** Test Cases ***
SM69_T_CODE
    SM69_T_CODE