*** Settings ***
Resource    ../Tests/Resource/Heineken_We21.robot
Test Tags    Heineken_We21

*** Test Cases ***
System_logon
    System Logon
    We21_Tcode