*** Settings ***
Resource    ../Tests/Resource/Olympus_SIGS.robot
Test Tags    SIGS

*** Test Cases ***
System_logon
    System Logon
    SIGS_Tcodes