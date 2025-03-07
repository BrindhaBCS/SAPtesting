*** Settings ***
Resource    ../Tests/Resource/Heineken_SM61.robot
Suite Setup   Heineken_SM61.System Logon
Suite Teardown   Heineken_SM61.System Logout
Test Tags    SM61

*** Test Cases ***
check_SM61
    SM61