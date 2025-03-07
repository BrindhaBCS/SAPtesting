*** Settings ***
Resource    ../Tests/Resource/Heineken_RZ12.robot
Suite Setup   Heineken_RZ12.System Logon
Suite Teardown   Heineken_RZ12.System Logout
Test Tags    RZ12_1

*** Test Cases ***
check_RZ12
    RZ12