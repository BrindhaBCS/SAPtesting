*** Settings ***
Resource    ../Tests/Resource/Olympus_SECSTORE.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    sec_sto

*** Test Cases ***
SP1_SECSTORE
    SECSTORE