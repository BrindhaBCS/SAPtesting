*** Settings ***
Resource    ../Tests/Resource/Get_Latest_ST_PI_Version.robot
Force Tags   GetVersion
Suite Setup    Get_Latest_ST_PI_Version.login page
# Suite Teardown    ST_PI_Patchfile_Download.System Logout
 
*** Test Cases ***
Get the latest version of ST-PI support package 
    Software Download