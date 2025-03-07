*** Settings ***
Resource    ../Tests/Resource/Heineken_SMQS.robot
Test Tags    Heineken_SMQS
Suite Setup   Heineken_SMQS.System Logon
Suite Teardown   Heineken_SMQS.System Logout

*** Test Cases ***
SMQS_Tcodes
    SMQS_Tcodes