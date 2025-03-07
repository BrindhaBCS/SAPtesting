*** Settings ***
Resource    ../Tests/Resource/Heineken_Csadmin.robot
Test Tags    Heineken_Csadmin

*** Test Cases ***
System_logon
    System Logon
    Csadmin_Tcode