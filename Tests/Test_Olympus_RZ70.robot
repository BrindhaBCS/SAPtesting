*** Settings ***
Resource    ../Tests/Resource/Olympus_RZ70.robot
Test Tags    RZ70

*** Test Cases ***
System_logon
    System Logon
    RZ70_Tcodes