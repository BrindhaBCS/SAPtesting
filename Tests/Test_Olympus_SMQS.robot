*** Settings ***
Resource    ../Tests/Resource/Olympus_SMQS.robot
Test Tags    Olympus_SMQS

*** Test Cases ***
System_logon
    System Logon
    SMQS_Tcodes