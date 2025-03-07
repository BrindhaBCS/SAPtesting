*** Settings ***
Resource    ../Tests/Resource/Heineken_SMQS.robot
Test Tags    Heineken_SMQS

*** Test Cases ***
System_logon
    System Logon
    SMQS_Tcodes