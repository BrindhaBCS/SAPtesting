*** Settings ***
Resource    ../Tests/Resource/Olympus_SM69.robot
Test Tags    SM69

*** Test Cases ***
SM69
    System Logon
    SM69_Tcodes
