*** Settings ***
Resource    ../Tests/Resource/Heineken_Spnego.robot
Test Tags    Heineken_Spnego
Suite Setup   Heineken_Spnego.System Logon
Suite Teardown   Heineken_Spnego.System Logout

*** Test Cases ***
Spnego_Tcode
    Spnego_Tcode