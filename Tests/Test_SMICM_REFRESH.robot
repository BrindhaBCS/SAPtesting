*** Settings ***
Resource    ../Tests/Resource/SMICM_REFRESH.robot   
Suite Setup    SMICM_REFRESH.System Logon
Suite Teardown    SMICM_REFRESH.System Logout
Task Tags    SMICM_REFRESH
 
 
*** Test Cases ***
SMICM_T_CODE
    SMICM_T_CODE