*** Settings ***
Resource    ../Tests/Resource/Heineken_STMS.robot
Suite Setup   Heineken_STMS.System Logon
Suite Teardown   Heineken_STMS.System Logout
Test Tags    Hei_STMS

*** Test Cases ***
check_STMS
    STMS