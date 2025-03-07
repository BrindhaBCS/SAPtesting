*** Settings ***
Resource    ../Tests/Resource/Heineken_Bd54.robot
Test Tags    Heineken_Bd54
Suite Setup   Heineken_Bd54.System Logon
Suite Teardown   Heineken_Bd54.System Logout

*** Test Cases ***
Bd54_Tcode
    Bd54_Tcode
   