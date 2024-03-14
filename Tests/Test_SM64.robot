*** Settings ***
Resource    ../Tests/Resource/SM64.robot
Suite Setup    SM64.System Logon
Suite Teardown    SM64.System Logout 
Test Tags    SM64_ST

*** Test Cases ***
SM64
    SM64