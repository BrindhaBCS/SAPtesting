*** Settings ***
Resource    ../Tests/Resource/Olympus_ST06.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    ST06

*** Test Cases ***
SP1_St06
    ST06