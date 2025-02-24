*** Settings ***
Resource    ../Tests/Resource/Olympus_SM37.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SM37

*** Test Cases ***
SP1_SMLG
    SM37