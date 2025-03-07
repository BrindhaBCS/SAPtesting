*** Settings ***
Resource    ../Tests/Resource/Heineken_RZ70.robot
Suite Setup   Heineken_RZ70.System Logon
Suite Teardown   Heineken_RZ70.System Logout
Test Tags    RZ70_1

*** Test Cases ***
check_RZ70
    RZ70