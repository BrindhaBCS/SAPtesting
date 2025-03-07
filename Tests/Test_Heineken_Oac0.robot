*** Settings ***
Resource    ../Tests/Resource/Heineken_Oac0.robot
Test Tags    Heineken_Oac0
Suite Setup   Heineken_Oac0.System Logon
Suite Teardown   Heineken_Oac0.System Logout

*** Test Cases ***
Oac0_Tcode
    Oac0_Tcode