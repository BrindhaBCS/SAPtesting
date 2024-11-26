*** Settings ***
Resource    ../Tests/Resource/DELETE_ROLE_NIKE.robot
Suite Setup    DELETE_ROLE_NIKE.System Logon
Suite Teardown    DELETE_ROLE_NIKE.System Logout
Task Tags    delete_role
 
 
*** Test Cases ***
delete_role
    delete_role