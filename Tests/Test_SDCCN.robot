*** Settings ***
Resource    ../Tests/Resource/SDCCN.robot
Suite Setup    SDCCN.System Logon
Suite Teardown    SDCCN.System Logout 
Test Tags    SDCCN_ST

*** Test Cases ***
SDCCN
    SDCCN
