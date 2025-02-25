*** Settings ***
Resource    ../Tests/Resource/Olympu_Smt2.robot
Task Tags    Olympus_smt2

*** Test Cases ***
System_logon
    System Logon
    smt2_Tcodes