*** Settings ***
Resource    ../Tests/Resource/Heineken_So50.robot
Test Tags    Heineken_So50

*** Test Cases ***
System_logon
    System Logon
    So50_Tcode