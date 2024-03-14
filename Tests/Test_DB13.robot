*** Settings ***
Resource    ../Tests/Resource/DB13.robot
Suite Setup    DB13.System Logon
Suite Teardown    DB13.System Logout 
Test Tags    DB13_ST

*** Test Cases ***
DB13
    DB13