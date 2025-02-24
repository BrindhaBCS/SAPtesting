*** Settings ***
Resource    ../Tests/Resource/Olympus_AL11.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    AL11

*** Test Cases ***
SP1_AL11
    AL11