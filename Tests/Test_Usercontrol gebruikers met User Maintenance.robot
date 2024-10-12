*** Settings ***
Resource    ../Tests/Resource/Usercontrol gebruikers met User Maintenance.robot
Suite Setup    Usercontrol gebruikers met User Maintenance.System Logon
Suite Teardown    Usercontrol gebruikers met User Maintenance.System Logout
Test Tags    Usercontrol_gebruikers_met_User_Maintenance

*** Test Cases ***
Usercontrol gebruikers met User Maintenance
    Usercontrol gebruikers met User Maintenance