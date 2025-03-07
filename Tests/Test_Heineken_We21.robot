*** Settings ***
Resource    ../Tests/Resource/Heineken_We21.robot
Test Tags    Heineken_We21
Suite Setup   Heineken_We21.System Logon
Suite Teardown   Heineken_We21.System Logout


*** Test Cases ***
We21_Tcode
    We21_Tcode