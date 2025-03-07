*** Settings ***
Resource    ../Tests/Resource/Heineken_FILE.robot
Suite Setup   Heineken_FILE.System Logon
Suite Teardown   Heineken_FILE.System Logout
Test Tags    FILE_1

*** Test Cases ***
check_FILE
    FILE