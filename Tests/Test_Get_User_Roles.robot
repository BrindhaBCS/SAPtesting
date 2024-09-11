*** Settings ***
Resource    ../Tests/Resource/Get_User_Roles.robot 
Suite Setup    Get_User_Roles.System Logon
Suite Teardown    Get_User_Roles.System Logout
Task Tags    Get_User_role
 
 
*** Test Cases ***
Write User Role into Excel sheet
    Getting User Role
    # Excel sheet