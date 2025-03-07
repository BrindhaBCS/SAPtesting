*** Settings ***
Resource    ../Tests/Resource/Heineken_Oac0.robot
Test Tags    Heineken_Oac0

*** Test Cases ***
System_logon
    System Logon
    Oac0_Tcode