*** Settings ***
Resource    ../Tests/Resource/Roles_User_Create.robot
Suite Setup    Roles_User_Create.System Logon
Suite Teardown    Roles_User_Create.System Logout
Test Tags    Roles_User_Create

*** Test Cases ***
Create_new_user
    Create_new_user
    System Logout
    Login_New_User