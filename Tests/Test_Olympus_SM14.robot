*** Settings ***
Resource    ../Tests/Resource/Olympus_SM14.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SM14

*** Test Cases ***
SP1_sm14
    SM14