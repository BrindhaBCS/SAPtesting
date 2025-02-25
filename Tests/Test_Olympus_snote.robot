*** Settings ***
Resource    ../Tests/Resource/Olympus_snote.robot
Task Tags    Olympus_snote

*** Test Cases ***
System_logon
    System Logon
    Snote