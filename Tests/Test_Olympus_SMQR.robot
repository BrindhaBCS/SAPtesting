*** Settings ***
Resource    ../Tests/Resource/Olympus_SMQR.robot
Test Tags    Olympus_SMQR

*** Test Cases ***
System_logon
    System Logon
    SMQR_Tcodes