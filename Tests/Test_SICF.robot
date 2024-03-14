*** Settings ***
Resource    ../Tests/Resource/SICF.robot
Suite Setup    SICF.System Logon
Suite Teardown    SICF.System Logout 
Test Tags    SICF_ST

*** Test Cases ***
SICF
    SICF