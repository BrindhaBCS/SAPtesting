*** Settings ***
Resource    ../Tests/Resource/RZ03.robot
Suite Setup    RZ03.System Logon
Suite Teardown    RZ03.System Logout 
Test Tags    RZ03_ST

*** Test Cases ***
RZ03
    RZ03