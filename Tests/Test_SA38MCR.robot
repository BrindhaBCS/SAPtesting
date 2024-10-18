*** Settings ***
Resource    ../Tests/Resource/SA38MCR.robot
# Test Tags    MCR_loop
Suite Setup    SA38MCR.System Logon
Suite Teardown    SA38MCR.System Logout
Test Tags    SA38

*** Test Cases ***
MCR
    Transaction SA38