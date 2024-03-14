*** Settings ***
Resource    ../Tests/Resource/RZ10.robot
Suite Setup    RZ10.System Logon
Suite Teardown    RZ10.System Logout 
Test Tags    RZ10_ST

*** Test Cases ***
RZ10
    RZ10