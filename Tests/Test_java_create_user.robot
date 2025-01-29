*** Settings ***
Resource    ../Tests/Resource/java_create_user.robot
Test Tags    java_version_createuserid
Suite Setup    java_create_user.Opening Browser
Suite Teardown    java_create_user.close_browser


*** Test Cases ***
Create_user_id
    Create_user_id
    
    