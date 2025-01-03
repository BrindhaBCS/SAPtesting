*** Settings ***
Resource    ../Tests/Resource/ST_PI_Patchfile_Download.robot
Force Tags   patch_dwld
Suite Setup    ST_PI_Patchfile_Download.System Logon
Suite Teardown    ST_PI_Patchfile_Download.System Logout
 
*** Test Cases ***
Download the support package files from SAP portal for ST-PI
    Verify Maintenance Certificate
