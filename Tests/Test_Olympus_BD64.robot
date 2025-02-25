*** Settings ***
Resource    ../Tests/Resource/Olympus_BD64.robot
Test Tags    BD64

*** Test Cases ***
System_logon
    System Logon
    BD64_Tcodes