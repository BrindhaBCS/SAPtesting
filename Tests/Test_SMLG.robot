*** Settings ***
Resource    ../Tests/Resource/SMLG.robot
Suite Setup    SMLG.System Logon
Suite Teardown    SMLG.System Logout 
Test Tags    SMLG_ST

*** Test Cases ***
SMLG
    SMLG