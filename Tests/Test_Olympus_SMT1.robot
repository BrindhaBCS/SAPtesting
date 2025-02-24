*** Settings ***
Resource    ../Tests/Resource/Olympus_SMT1.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SMT1

*** Test Cases ***
SP1_SMT1
    SMT1