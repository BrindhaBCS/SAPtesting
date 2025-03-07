*** Settings ***
Resource    ../Tests/Resource/Heineken_Bd54.robot
Test Tags    Heineken_Bd54

*** Test Cases ***
System_logon
    System Logon
    Bd54_Tcode