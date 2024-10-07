*** Settings ***
Resource    ../Tests/Resource/Newinhance_masterMaterial.robot
Suite Setup    Newinhance_masterMaterial.System Logon
Suite Teardown    Newinhance_masterMaterial.System Logout
Test Tags    Material_new


*** Test Cases ***
Material_master
    Material_master
     
    