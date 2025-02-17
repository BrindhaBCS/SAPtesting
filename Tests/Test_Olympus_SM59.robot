*** Settings ***
Resource    ../Tests/Resource/Olympus_SM59.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SM59

*** Test Cases ***
SP1_SM59
    SM59