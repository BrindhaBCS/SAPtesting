*** Settings ***
Resource    ../Tests/Resource/Olympus_LTRC.robot
Test Tags    Olympus_LTRc

*** Test Cases ***
System_logon
    System Logon
    LTRC_Tcodes