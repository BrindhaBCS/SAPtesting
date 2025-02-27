*** Settings ***
Resource    ../Tests/Resource/Olympus_LC10.robot
Test Tags    LC10

*** Test Cases ***
System_logon
    System Logon
    LC10_Tcodes


