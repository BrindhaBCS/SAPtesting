*** Settings ***
Resource    ../Tests/Resource/Olympus_SM58.robot
Test Tags    SM58

*** Test Cases ***
System_logon
    System Logon
    SM58_Tcodes