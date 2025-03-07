*** Settings ***
Resource    ../Tests/Resource/Heineken_AL11.robot
Suite Setup   Heineken_AL11.System Logon
Suite Teardown   Heineken_AL11.System Logout
Test Tags    AL11

*** Test Cases ***
check_AL11
    AL11