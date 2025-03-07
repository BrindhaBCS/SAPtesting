*** Settings ***
Resource    ../Tests/Resource/Heineken_Sm63.robot
Test Tags    Heineken_SM63

*** Test Cases ***
System_logon
    System Logon
    SM63_Tcode