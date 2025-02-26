*** Settings ***
Resource    ../Tests/Resource/Olympus_RZ11.robot
Test Tags    Olympus_RZ11
 
*** Test Cases ***
System_logon
    System Logon
    RZ11_Tcodes
 