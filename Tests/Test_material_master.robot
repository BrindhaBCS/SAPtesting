*** Settings ***
Resource    ../Tests/Resource/material_master.robot
Resource    ../Tests/Resource/material_master_1_.robot
# Suite Setup    material_master.System Logon
# Suite Teardown    material_master.System Logout
# Test Tags    Material1



*** Test Cases ***
Material_master1
    [Tags]    Material_m
    [Setup]    material_master_1_.System Logon
    Material_master1
    [Teardown]    material_master_1_.System Logout
Material_master
    [Tags]    Material1
    [Setup]    material_master.System Logon
    Material_master
    [Teardown]    material_master.System Logout
        
     
    