*** Settings ***
Resource    ../Tests/Resource/Olympus_SMLG.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SMLG

*** Test Cases ***
SP1_SMLG
    SMLG