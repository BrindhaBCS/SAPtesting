*** Settings ***
Resource    ../Tests/Resource/USER_ROLE_ASSIGN_NIKE.robot 
Suite Setup    USER_ROLE_ASSIGN_NIKE.System Logon
Suite Teardown    USER_ROLE_ASSIGN_NIKE.System Logout
Task Tags    User_role
 
 
*** Test Cases ***
user_role_assign
    [Tags]      Add_role
    Assigning Roles to the User

Removing User Roles
    [Tags]      Remove_role
    user_role_Remove