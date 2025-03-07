*** Settings ***
Resource    ../Tests/Resource/Heineken_We20.robot
Test Tags    Heineken_We20

*** Test Cases ***
System_logon
    System Logon
    We20_Tcode