*** Settings ***
Resource    ../Tests/Resource/AL11.robot
Suite Setup    AL11.System Logon
Suite Teardown    AL11.System Logout 
Test Tags    AL11_ST

*** Test Cases ***
AL11
    AL11