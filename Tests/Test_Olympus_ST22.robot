*** Settings ***
Resource    ../Tests/Resource/Olympus_ST22.robot
Test Tags    ST22

*** Test Cases ***
System_logon
    System Logon
    ST22_Tcodes