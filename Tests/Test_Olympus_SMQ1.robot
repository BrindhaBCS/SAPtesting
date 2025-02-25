*** Settings ***
Resource    ../Tests/Resource/Olympus_SMQ1.robot
Test Tags    SMQ1

*** Test Cases ***
System_logon
    System Logon
    SMQ1_Tcodes