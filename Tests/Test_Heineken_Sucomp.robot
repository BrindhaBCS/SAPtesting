*** Settings ***
Resource    ../Tests/Resource/Heineken_Sucomp.robot
Suite Setup   Heineken_Sucomp.System Logon
Suite Teardown   Heineken_Sucomp.System Logout
Test Tags    Sucomp

*** Test Cases ***
check_Sucomp
    Sucomp