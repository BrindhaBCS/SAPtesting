*** Settings ***
Resource    ../Tests/Resource/License_renewal.robot
Force Tags   license
Suite Setup    License_renewal.System Logon
Suite Teardown    License_renewal.System Logout
 
*** Test Cases ***
Renewal of license
    License Renewal