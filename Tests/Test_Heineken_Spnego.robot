*** Settings ***
Resource    ../Tests/Resource/Heineken_Spnego.robot
Test Tags    Heineken_Spnego

*** Test Cases ***
System_logon
    System Logon
    Spnego_Tcode