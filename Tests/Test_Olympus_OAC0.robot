*** Settings ***
Resource    ../Tests/Resource/Olympus_OAC0.robot
Test Tags    Olympus_OAC0

*** Test Cases ***
System_logon
    System Logon
    OAC0_Tcodes