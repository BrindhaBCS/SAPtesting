*** Settings ***
Resource    ../Tests/Resource/Olympus_SLDAPICUST.robot
Test Tags    SLDAPICUST

*** Test Cases ***
System_logon
    System Logon
    SLDAPICUST_tcode