*** Settings ***
Resource    ../Tests/Resource/Heineken_Smicm.robot
Suite Setup   Heineken_Smicm.System Logon
Suite Teardown   Heineken_Smicm.System Logout
Test Tags    Smicm

*** Test Cases ***
check_Smicm
    Smicm