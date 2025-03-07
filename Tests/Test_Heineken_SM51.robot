*** Settings ***
Resource    ../Tests/Resource/Heineken_SM51.robot
Suite Setup   Heineken_SM51.System Logon
Suite Teardown   Heineken_SM51.System Logout
Test Tags    SM51

*** Test Cases ***
check_SM51
    SM51