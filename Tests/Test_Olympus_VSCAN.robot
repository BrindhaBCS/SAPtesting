*** Settings ***
Resource    ../Tests/Resources/Olympus_VSCAN.robot
Test Tags    VSCAN

*** Test Cases ***
System_logon
    System Logon
    VSCAN_Tcodes