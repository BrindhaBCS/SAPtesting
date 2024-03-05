*** Settings ***
Resource    ../Tests/Resource/SMGW_REFRESH.robot  
Suite Setup    SMGW_REFRESH.System Logon
Suite Teardown    SMGW_REFRESH.System Logout
Task Tags    SMGW_REFRESH
 
 
*** Test Cases ***
SMGW_T_CODE
    SMGW_T_CODE