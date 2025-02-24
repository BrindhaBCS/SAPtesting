*** Settings ***
Resource    ../Tests/Resource/Olympus_SM20.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SM20

*** Test Cases ***
SP1_sm20
    SM20