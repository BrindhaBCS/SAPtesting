*** Settings ***
Resource    ../Tests/Resource/powerconnect.robot
Task Tags   powerconnect
Suite Setup    powerconnect.System Logon
Suite Teardown    powerconnect.System Logout
 
 
*** Test Cases ***
Check_Saint Transation Code
    Saint Transation Code
    Get Cell Text From SAP Table
  
Selecting the path for the Addon
    Patch selection for the Addon
    Important SAP note handling
    FOR ST/BNWVS 

Process Until Finish Button Visible
    Process Until Finish Button Visible



