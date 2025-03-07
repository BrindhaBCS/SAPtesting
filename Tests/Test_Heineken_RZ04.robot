*** Settings ***
Resource    ../Tests/Resource/Heineken_RZ04.robot
Suite Setup   Heineken_RZ04.System Logon
Suite Teardown   Heineken_RZ04.System Logout
Test Tags    RZ04_1

*** Test Cases ***
check_RZ04
    RZ04