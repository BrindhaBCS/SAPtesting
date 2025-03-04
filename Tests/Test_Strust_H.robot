*** Settings ***
Resource    ../Tests/Resource/Strust_H.robot
Test Tags    Strust_heineken
Suite Setup   Strust_H.System Logon
Suite Teardown   Strust_H.System Logout

*** Test Cases ***
STRUST
    STRUST
    System_PSE
    SNC_SAPCRYPTOLIB
    SSL server standard 
    SSL client SSL Client (Anonymous)
    SSL client SSL Client (Standard)
    