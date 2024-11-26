*** Settings ***
Resource    ../Tests/Resource/material.robot
Suite Setup    material.System Logon
# Suite Teardown    DOWNLOAD_ROLE_NIKE.System Logout
Task Tags    material
 
 
*** Test Cases ***
Material_master
    Material_master