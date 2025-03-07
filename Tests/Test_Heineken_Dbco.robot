*** Settings ***
Resource    ../Tests/Resource/Heineken_Dbco.robot
Test Tags    Heineken_Dbco
Suite Setup   Heineken_Dbco.System Logon
Suite Teardown   Heineken_Dbco.System Logout

*** Test Cases ***
DBCO_Tcode
    DBCO_Tcode