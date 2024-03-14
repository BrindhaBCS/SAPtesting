*** Settings ***
Resource    ../Tests/Resource/SM63.robot
Suite Setup    SM63.System Logon
Suite Teardown    SM63.System Logout 
Test Tags    SM63_ST

*** Test Cases ***
SM63
    SM63