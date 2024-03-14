*** Settings ***
Resource    ../Tests/Resource/SM14.robot
Suite Setup    SM14.System Logon
Suite Teardown    SM14.System Logout 
Test Tags    SM14_ST

*** Test Cases ***
SM14
    SM14