*** Settings ***
Resource    ../Tests/Resource/SMQS_REFRESH.robot   
Suite Setup    SMQS_REFRESH.System Logon
Suite Teardown    SMQS_REFRESH.System Logout
Task Tags    SMQS_REFRESH
 
 
*** Test Cases ***
SMQS_T_CODE
    SMQS_T_CODE