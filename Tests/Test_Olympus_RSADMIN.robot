*** Settings ***
Resource    ../Tests/Resource/Olympus_RSADMIN.robot
Test Tags    RSADMIN

*** Test Cases ***
System_logon
    System Logon
    RSADMIN