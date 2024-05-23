*** Settings ***
Resource    ../Tests/Resource/DELETE_role.robot
Suite Setup    DELETE_role.System Logon
Suite Teardown    DELETE_role.System Logout
Task Tags    delete_role
 
 
*** Test Cases ***
delete_role
    delete_role