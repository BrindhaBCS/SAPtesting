*** Settings ***
Resource    ../Tests/Resource/Heineken_Sm69.robot
Test Tags    Heineken_SM69
Suite Setup   Heineken_Sm69.System Logon
Suite Teardown   Heineken_Sm69.System Logout

*** Test Cases ***
SM69_Tcode
    SM69_Tcode