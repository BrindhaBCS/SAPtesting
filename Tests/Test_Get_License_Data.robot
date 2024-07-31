*** Settings ***
Resource    ../Tests/Resource/License_renewal.robot
Force Tags   get_license
Suite Setup    License_renewal.System Logon
Suite Teardown    License_renewal.System Logout
 
*** Test Cases ***
Get data for license renewal
    Get License Data