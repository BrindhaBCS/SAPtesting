*** Settings ***
Resource    ../Tests/Resource/Heineken_Saml2.robot 
Test Tags    Heineken_Saml2

*** Test Cases ***
System_logon
    System Logon
    Saml2_Tcode