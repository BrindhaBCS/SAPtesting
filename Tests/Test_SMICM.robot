*** Settings ***
Resource    ../Tests/Resource/SMICM.robot
Suite Setup    SMICM.System Logon
Suite Teardown    SMICM.System Logout 
Test Tags    SMICM_ST

*** Test Cases ***
SMICM
    SMICM