*** Settings ***
Resource    ../Tests/Resource/Versions_check_All.robot
Force Tags   STPI
Suite Setup    Versions_check_All.System Logon
Suite Teardown    Versions_check_All.System Logout
 
*** Test Cases ***
Verifying ST-PI Component Status
    Component ST-PI Version