*** Settings ***
Resource    ../Tests/Resource/Olympus_ICNV.robot
Test Tags    ICNV

*** Test Cases ***
System_logon
    System Logon
    ICNV_Tcodes