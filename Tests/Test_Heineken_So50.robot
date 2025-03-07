*** Settings ***
Resource    ../Tests/Resource/Heineken_So50.robot
Test Tags    Heineken_So50
Suite Setup   Heineken_So50.System Logon
Suite Teardown   Heineken_So50.System Logout

*** Test Cases ***
So50_Tcode
    So50_Tcode