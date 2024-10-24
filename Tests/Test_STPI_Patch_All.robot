*** Settings ***
Resource    ../Tests/Resource/STPI_Patch_All.robot
Force Tags   ST_PI_Patch
Suite Setup    STPI_Patch_All.System Logon
Suite Teardown    STPI_Patch_All.System Logout
 
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