*** Settings ***
Resource    ../Tests/Resource/Heineken_SMQR.robot
Test Tags    Heineken_SMQR
Suite Setup   Heineken_SMQR.System Logon
Suite Teardown   Heineken_SMQR.System Logout

*** Test Cases ***
SMQR_Tcodes
    SMQR_Tcodes