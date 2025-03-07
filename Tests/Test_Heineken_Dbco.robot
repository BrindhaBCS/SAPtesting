*** Settings ***
Resource    ../Tests/Resource/Heineken_Dbco.robot
Test Tags    Heineken_Dbco

*** Test Cases ***
System_logon
    System Logon
    DBCO_Tcode