*** Settings ***
Resource    ../Tests/Resource/Olympus_SAML2.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    SAML2

*** Test Cases ***
SP1_SAML2
    SAML2