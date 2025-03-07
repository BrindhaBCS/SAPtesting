*** Settings ***
Resource    ../Tests/Resource/Heineken_SMQR.robot
Test Tags    Heineken_SMQR

*** Test Cases ***
System_logon
    System Logon
    SMQR_Tcodes