*** Settings ***
Resource    ../Tests/Resource/Heineken_STZAC.robot
Test Tags    Heineken_STZAC

*** Test Cases ***
System_logon
    System Logon
    STZAC_Tcodes