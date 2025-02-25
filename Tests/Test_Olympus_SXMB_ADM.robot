*** Settings ***
Resource    ../Tests/Resource/Olympus_SXMB_ADM.robot
Test Tags    SXMB_ADM

*** Test Cases ***
System_logon
    System Logon
    SXMB_ADM_Tcodes