*** Settings ***
Resource    ../Tests/Resource/USER_ROLE_ASSIGN_NIKE.robot
Suite Setup    USER_ROLE_ASSIGN_NIKE.System Logon
Suite Teardown    USER_ROLE_ASSIGN_NIKE.System Logout
Task Tags    User_role
 
 
*** Test Cases ***
user_role_assign
    user_role_assign