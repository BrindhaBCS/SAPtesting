*** Settings ***
Resource    ../Tests/Resource/Heineken_Sxmb_adm.robot
Test Tags    Heineken_Sxmb_adm
Suite Setup   Heineken_Sxmb_adm.System Logon
Suite Teardown   Heineken_Sxmb_adm.System Logout

*** Test Cases ***
Sxmb_adm_Tcode
    Sxmb_adm_Tcode