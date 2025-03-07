*** Settings ***
Resource    ../Tests/Resource/Heineken_STZAC.robot
Test Tags    Heineken_STZAC
Suite Setup   Heineken_STZAC.System Logon
Suite Teardown   Heineken_STZAC.System Logout

*** Test Cases ***
STZAC_Tcodes
    STZAC_Tcodes