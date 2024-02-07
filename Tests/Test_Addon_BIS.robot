*** Settings ***
Resource    ../Tests/Resource/Addon_BIS.robot
Resource    ../Tests/Resource/Common_Function_BIS.robot
Task Tags   SAPTEST
Suite Setup    Common_Function_BIS.System Logon
Suite Teardown    Common_Function_BIS.System Logout
 
 
*** Test Cases ***

Check_Saint Transation Code
    Saint Transation Code
    Get Cell Text From SAP Table
  
# Selecting the path for the Addon
#     Patch selection for the Addon
#     Important SAP note handling
#     FOR ST/BNWVS 

# Process Until Finish Button Visible
#     Process Until Finish Button Visible




