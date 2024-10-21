*** Settings ***
Resource    ../Tests/Resource/Versions_check.robot
Force Tags   sapversion
Suite Setup    Versions_check.System Logon
Suite Teardown    Versions_check.System Logout
 
*** Test Cases ***
Verifying SAP System Status
    SAP BASIS Release
    SAP UI Release