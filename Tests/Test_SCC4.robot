*** Settings ***
Resource    ../Tests/Resource/SCC4.robot
Suite Setup    SCC4.System Logon
Suite Teardown    SCC4.System Logout 
Test Tags    SCC4_ST

*** Test Cases ***
SCC4
    SCC4