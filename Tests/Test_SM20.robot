*** Settings ***
Resource    ../Tests/Resource/SM20.robot
Suite Setup    SM20.System Logon
Suite Teardown    SM20.System Logout 
Test Tags    SM20_ST

*** Test Cases ***
SM20
    SM20