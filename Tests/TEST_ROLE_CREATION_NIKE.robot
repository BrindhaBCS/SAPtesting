*** Settings ***
Resource    ../Tests/Resource/ROLE_CREATION_NIKE.robot
Suite Setup    ROLE_CREATION_NIKE.System Logon
Suite Teardown    ROLE_CREATION_NIKE.System Logout
Task Tags    role_create
 
 
*** Test Cases ***
create_role
    create_role