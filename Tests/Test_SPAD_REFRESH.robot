*** Settings ***
Resource    ../Tests/Resource/SPAD_REFRESH.robot 
Suite Setup    SPAD_REFRESH.System Logon
Suite Teardown    SPAD_REFRESH.System Logout
Task Tags    SPAD_REFRESH
 
 
*** Test Cases ***
SPAD
    SPAD