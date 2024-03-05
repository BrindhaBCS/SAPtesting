*** Settings ***
Resource    ../Tests/Resource/SMLG_REFRESH.robot   
Suite Setup    SMLG_REFRESH.System Logon
Suite Teardown    SMLG_REFRESH.System Logout
Task Tags    SMLG_REFRESH
 
 
*** Test Cases ***
SMLG_T_CODE
    SMLG_T_CODE