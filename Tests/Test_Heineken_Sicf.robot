*** Settings ***
Resource    ../Tests/Resource/Heineken_Sicf.robot
Test Tags    Heineken_Sicf
Suite Setup   Heineken_Sicf.System Logon
Suite Teardown   Heineken_Sicf.System Logout

*** Test Cases ***
Sicf_Tcode
    Sicf_Tcode