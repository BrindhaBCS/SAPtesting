*** Settings ***
Resource    ../Tests/Resource/Heineken_SMLG.robot
Suite Setup   Heineken_SMLG.System Logon
Suite Teardown   Heineken_SMLG.System Logout
Test Tags    SMLG_1

*** Test Cases ***
check_SMLG
    SMLG