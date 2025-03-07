*** Settings ***
Resource    ../Tests/Resource/Heineken_Sm69.robot
Test Tags    Heineken_SM69

*** Test Cases ***
System_logon
    System Logon
    SM69_Tcode