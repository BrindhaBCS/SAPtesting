*** Settings ***
Resource    ../Tests/Resource/Olympus_SM61.robot
Test Tags    SM61

*** Test Cases ***
System_logon
    System Logon
    SM61_Tcodes