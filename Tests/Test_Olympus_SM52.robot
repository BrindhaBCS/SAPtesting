*** Settings ***
Resource    ../Tests/Resource/Olympus_SM52.robot
Test Tags    SM52

*** Test Cases ***
System Logon
    System Logon
    SM52_Tcodes
