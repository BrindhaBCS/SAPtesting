*** Settings ***
Resource    ../Tests/Resource/SM49.robot
Suite Setup    SM49.System Logon
Suite Teardown    SM49.System Logout 
Test Tags    SM49_ST

*** Test Cases ***
SM49
    SM49