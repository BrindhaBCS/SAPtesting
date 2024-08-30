*** Settings ***
Resource    ../Tests/Resource/Roles_Create_date.robot
Suite Setup    Roles_Create_date.System Logon
Suite Teardown    Roles_Create_date.System Logout 
Test Tags    Roles_Create_date

*** Test Cases ***
Get roles from Table
    Get roles from Table
    System Logout
    TEST_System_Logon
    Test_User
    System Logout
    System Logon
    Own_User