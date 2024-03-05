*** Settings ***
Resource    ../Tests/Resource/SMQR_REFRESH.robot   
Suite Setup    SMQR_REFRESH.System Logon
Suite Teardown    SMQR_REFRESH.System Logout
Task Tags    SMQR_REFRESH
 
 
*** Test Cases ***
SMQR_T_CODE
    SMQR_T_CODE