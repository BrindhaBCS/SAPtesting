*** Settings ***
Resource    ../Tests/Resource/SCOT.robot
Suite Setup    SCOT.System Logon
Suite Teardown    SCOT.System Logout 
Test Tags    SCOT_ST

*** Test Cases ***
SCOT
    SCOT