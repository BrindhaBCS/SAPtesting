*** Settings ***
Resource    ../Tests/Resource/material_master.robot
Suite Setup    material_master.System Logon
Suite Teardown    material_master.System Logout
Test Tags    Material1


*** Test Cases ***
Material_master
    [Tags]    Material_m
    Material_master
    
     
    