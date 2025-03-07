*** Settings ***
Resource    ../Tests/Resource/Heineken_RZ03.robot
Suite Setup   Heineken_RZ03.System Logon
Suite Teardown   Heineken_RZ03.System Logout
Test Tags    RZ03_1

*** Test Cases ***
check_RZ03
    RZ03