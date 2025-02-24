*** Settings ***
Resource    ../Tests/Resource/Olympus_SM51.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SM51

*** Test Cases ***
SP1_SMLG
    SM51