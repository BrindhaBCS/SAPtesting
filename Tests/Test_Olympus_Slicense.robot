*** Settings ***
Resource    ../Tests/Resource/Olympus_Slicense.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    Slicense

*** Test Cases ***
SP1_SLINCESE
    Slicense