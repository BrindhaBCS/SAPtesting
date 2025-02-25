*** Settings ***
Resource    ../Tests/Resource/Olympus_SM53.robot
Test Tags    SM53

*** Test Cases ***
System_logon
    System Logon
    SM53_Tcodes