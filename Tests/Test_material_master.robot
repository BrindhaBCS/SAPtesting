*** Settings ***
Resource    ../Tests/Resource/material_master.robot
Suite Setup    material_master.System Logon
Suite Teardown    material_master.System Logout
Test Tags    Material1


*** Test Cases ***
Material_master
    Material_master
     
    