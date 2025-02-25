*** Settings ***
Resource    ../Tests/Resource/Olympus_RZ12.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    RZ12

*** Test Cases ***
SP1_SMLG
    RZ12