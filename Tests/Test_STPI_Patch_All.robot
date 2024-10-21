*** Settings ***
Resource    ../Tests/Resource/STPI_Patch.robot
Force Tags   ST_PI_Patch
Suite Setup    STPI_Patch.System Logon
Suite Teardown    STPI_Patch.System Logout
 
*** Test Cases ***
Patching the ST-PI support package into latest release
    Spam Certificate Verification
    Loading package
    Display/Define
    Spam Component selection
    Spam Patch selection
    Important SAP note handling
    Importing queue from support package
    Confirm Queue