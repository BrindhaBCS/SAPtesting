*** Settings ***
Resource    ../Tests/Resource/SWU3.robot
Suite Setup    SWU3.System Logon
Suite Teardown    SWU3.System Logout 
Test Tags    SWU3_ST

*** Test Cases ***
SWU3
    SWU3
