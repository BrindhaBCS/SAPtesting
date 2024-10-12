*** Settings ***
Resource    ../Tests/Resource/Mandantonderhoud.robot
Suite Setup    Mandantonderhoud.System Logon
Suite Teardown   Mandantonderhoud.System Logout
Test Tags    Mandantonderhoud

*** Test Cases ***
Mandantonderhoud
    Mandantonderhoud