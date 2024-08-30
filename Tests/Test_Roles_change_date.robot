*** Settings ***
Resource    ../Tests/Resource/Roles_change_date.robot
Suite Setup    Roles_change_date.System Logon
Suite Teardown    Roles_change_date.System Logout 
Test Tags    Roles_change_date
*** Test Cases ***
Change Date
    Change Date
    Create new user
    System Logout
    TEST_System_Logon
    Test_User
    System Logout
    System Logon
    Own_User
    Deletefile