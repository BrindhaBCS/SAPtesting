*** Settings ***
Resource    ../Tests/Resource/SM63_REFRESH.robot
Suite Setup    SM63_REFRESH.System Logon
Suite Teardown    SM63_REFRESH.System Logout
Task Tags    SM63_REFRESH
 
 
*** Test Cases ***
SM63_T_CODE
    SM63_T_CODE