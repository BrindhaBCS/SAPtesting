*** Settings ***
Resource    ../Tests/Resource/Olympus_SICK.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SICK

*** Test Cases ***
SP1_SICK
    SICK