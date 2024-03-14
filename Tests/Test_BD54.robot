*** Settings ***
Resource    ../Tests/Resource/BD54.robot
Suite Setup    BD54.System Logon
Suite Teardown    BD54.System Logout 
Test Tags    BD54_ST

*** Test Cases ***
BD54
    BD54