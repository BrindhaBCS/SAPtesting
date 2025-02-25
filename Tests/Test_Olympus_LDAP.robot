*** Settings ***
Resource    ../Tests/Resource/Olympus_LDAP.robot
Test Tags    LDAP

*** Test Cases ***
System_logon
    System Logon
    LDAP_Tcodes