*** Settings ***
Resource    ../Tests/Resource/Heineken_We20.robot
Test Tags    Heineken_We20
Suite Setup   Heineken_We20.System Logon
Suite Teardown   Heineken_We20.System logout

*** Test Cases ***
We20_Tcode
    We20_Tcode