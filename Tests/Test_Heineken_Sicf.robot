*** Settings ***
Resource    ../Tests/Resource/Heineken_Sicf.robot
Test Tags    Heineken_Sicf

*** Test Cases ***
System_logon
    System Logon
    Sicf_Tcode