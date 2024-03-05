*** Settings ***
Resource    ../Tests/Resource/SCC4_REFRESH.robot  
Suite Setup    SCC4_REFRESH.System Logon
Suite Teardown    SCC4_REFRESH.System Logout
Task Tags    SCC4_REFRESH
 
 
*** Test Cases ***
SCC4_T_CODE
    SCC4_T_CODE
