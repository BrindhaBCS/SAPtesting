*** Settings ***
Resource    ../Tests/Resource/Heineken_Sxmb_adm.robot
Test Tags    Heineken_Sxmb_adm

*** Test Cases ***
System_logon
    System Logon
    Sxmb_adm_Tcode