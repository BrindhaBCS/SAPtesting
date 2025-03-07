*** Settings ***
Resource    ../Tests/Resource/Heineken_Sbgrfcconf.robot
Test Tags    Sbgrfcconf

*** Test Cases ***
System_logon
    System Logon
    Sbgrfcconf_Tcode
    