*** Settings ***
Resource    ../Tests/Resource/Heineken_Csadmin.robot
Test Tags    Heineken_Csadmin
Suite Setup   Heineken_Csadmin.System Logon
Suite Teardown   Heineken_Csadmin.System Logout

*** Test Cases ***
Csadmin_Tcode
    Csadmin_Tcode