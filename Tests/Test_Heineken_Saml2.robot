*** Settings ***
Resource    ../Tests/Resource/Heineken_Saml2.robot 
Test Tags    Heineken_Saml2
Suite Setup   Heineken_Saml2.System Logon
Suite Teardown   Heineken_Saml2.System Logout

*** Test Cases ***
Saml2_Tcode
    Saml2_Tcode