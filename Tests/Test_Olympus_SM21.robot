*** Settings ***
Resource    ../Tests/Resource/Olympus_SM21.robot
Test Tags    SM21

*** Test Cases ***
System_logon
    System Logon
    SM21_Tcodes