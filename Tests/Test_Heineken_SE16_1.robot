*** Settings ***
Resource    ../Tests/Resource/Heineken_SE16_1.robot
Suite Setup   Heineken_SE16_1.System Logon
Suite Teardown   Heineken_SE16_1.System Logout
Test Tags    SE16_1

*** Test Cases ***
check_SE16_1
    SE16_1