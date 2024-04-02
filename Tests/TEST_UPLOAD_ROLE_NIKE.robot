*** Settings ***
Resource    ../Tests/Resource/UPLOAD_ROLE_NIKE.robot 
Suite Setup    UPLOAD_ROLE_NIKE.System Logon
Suite Teardown    UPLOAD_ROLE_NIKE.System Logout
Task Tags    upload_role
 
 
*** Test Cases ***
uploading_role
    uploading_role