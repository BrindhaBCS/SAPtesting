*** Settings ***
Resource    ../Tests/Resource/Olympus_ST02.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    ST02

*** Test Cases ***
SP1_St02
    ST02