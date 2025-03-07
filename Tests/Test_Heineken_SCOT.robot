*** Settings ***
Resource    ../Tests/Resource/Heineken_SCOT.robot
Suite Setup   Heineken_SCOT.System Logon
Suite Teardown   Heineken_SCOT.System Logout
Test Tags    SCOT_1

*** Test Cases ***
check_SCOT
    SCOT