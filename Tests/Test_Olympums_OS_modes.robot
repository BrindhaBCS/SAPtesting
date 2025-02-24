*** Settings ***
Resource    ../Tests/Resource/Olympus_Op_modes.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    os_modes

*** Test Cases ***
SP1_SICK
    os_modes