*** Settings ***
Resource    ../Tests/Resource/SM61.robot
Suite Setup    SM61.System Logon
Suite Teardown    SM61.System Logout 
Test Tags    SM61_ST

*** Test Cases ***
SM61
    SM61