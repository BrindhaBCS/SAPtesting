*** Settings ***
Resource    ../Tests/Resource/Versions_check_All.robot
Force Tags   sapversion
Suite Setup    Versions_check_All.System Logon
Suite Teardown    Versions_check_All.System Logout
 
*** Test Cases ***
Verifying SAP System Status
    SAP BASIS Release
    SAP UI Release