*** Settings ***
Resource    ../Tests/Resource/Heineken_LC10.robot
Suite Setup   Heineken_LC10.System Logon
Suite Teardown   Heineken_LC10.System Logout
Test Tags    LC10_1

*** Test Cases ***
check_LC10
    LC10