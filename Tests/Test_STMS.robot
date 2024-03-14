*** Settings ***
Resource    ../Tests/Resource/STMS.robot
Suite Setup    STMS.System Logon
Suite Teardown    STMS.System Logout 
Test Tags    STMS_ST

*** Test Cases ***
STMS
    STMS
