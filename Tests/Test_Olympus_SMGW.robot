*** Settings ***
Resource    ../Tests/Resource/Olympus_SMGW.robot
Test Tags    Olympus_SMGW

*** Test Cases ***
System_logon
    System Logon
    SMGW_Tcodes