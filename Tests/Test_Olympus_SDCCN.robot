*** Settings ***
Resource    ../Tests/Resource/Olympus_SDCCN.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SDCCN

*** Test Cases ***
SP1_SDCCN
    SDCCN