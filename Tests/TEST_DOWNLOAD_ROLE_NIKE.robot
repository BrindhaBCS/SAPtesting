*** Settings ***
Resource    ../Tests/Resource/DOWNLOAD_ROLE_NIKE.robot
Suite Setup    DOWNLOAD_ROLE_NIKE.System Logon
Suite Teardown    DOWNLOAD_ROLE_NIKE.System Logout
Task Tags    download_role
 
 
*** Test Cases ***
download_role
    download_role