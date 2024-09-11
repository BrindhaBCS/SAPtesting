*** Settings ***
Resource    ../Tests/Resource/Versions_check.robot
Force Tags   STPIversion
Suite Setup    Versions_check.System Logon
Suite Teardown    Versions_check.System Logout
 
*** Test Cases ***
Verifying ST-PI Component Status
    Component ST-PI Version