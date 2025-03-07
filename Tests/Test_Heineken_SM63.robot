*** Settings ***
Resource    ../Tests/Resource/Heineken_Sm63.robot
Test Tags    Heineken_SM63
Suite Setup   Heineken_Sm63.System Logon
Suite Teardown   Heineken_Sm63.System Logout

*** Test Cases ***
SM63_Tcode
    SM63_Tcode