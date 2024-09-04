*** Settings ***
Resource    ../Tests/Resource/saint.robot
Task Tags   powerconnect
Suite Setup    saint.System Logon
Suite Teardown    saint.System Logout
 
 
*** Test Cases ***
Check_Saint Transation Code
    Saint Transation Code
    Get Cell Text From SAP Table
  
# Selecting the path for the Addon
#     Patch selection for the Addon
#     Important SAP note handling
#     Start Options
#     Import Option 

# Process Until Finish Button Visible
#     Process Until Finish Button Visible