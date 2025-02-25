*** Settings ***
Resource    ../Tests/Resource/Olympus_RZ03.robot
Test Tags    Olympus_RZ03

*** Test Cases ***
System_logon
    System Logon
    RZ03_Tcodes