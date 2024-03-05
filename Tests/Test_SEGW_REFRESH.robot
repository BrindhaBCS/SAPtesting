*** Settings ***
Resource    ../Tests/Resource/SEGW_REFRESH.robot
Suite Setup    SEGW_REFRESH.System Logon
Suite Teardown    SEGW_REFRESH.System Logout
Task Tags    SEGW_REFRESH
 
 
*** Test Cases ***
SEGW_T_CODE
    SEGW_T_CODE