*** Settings ***
Resource    ../Tests/Resource/Heineken_Sbgrfcconf.robot
Test Tags    Sbgrfcconf
Suite Setup   Heineken_Sbgrfcconf.System Logon
Suite Teardown   Heineken_Sbgrfcconf.System Logout

*** Test Cases ***
Sbgrfcconf_Tcode
    Sbgrfcconf_Tcode
    