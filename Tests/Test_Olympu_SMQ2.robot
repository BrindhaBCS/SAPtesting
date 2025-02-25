*** Settings ***
Resource    ../Tests/Resource/Olympus_SMQ2.robot
Test Tags    SMQ2

*** Test Cases ***
System_logon
    System Logon
    SMQ2_Tcodes