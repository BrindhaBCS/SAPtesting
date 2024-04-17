*** Settings ***
Resource    ../Tests/Resource/SECSTORE_REFRESH.robot   
Suite Setup    SECSTORE_REFRESH.System Logon
Suite Teardown    SECSTORE_REFRESH.System Logout
Task Tags    Secstore_REFRESH
 
 
*** Test Cases ***
SECSTORE_T_CODE
    SECSTORE_T_CODE