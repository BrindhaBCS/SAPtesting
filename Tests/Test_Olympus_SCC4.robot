*** Settings ***
Resource    ../Tests/Resource/Olympus_SCC4.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SCC4

*** Test Cases ***
SP1_SCC4
    SCC4