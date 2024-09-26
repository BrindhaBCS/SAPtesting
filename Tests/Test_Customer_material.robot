*** Settings ***
Resource    ../Tests/Resource/Customer_material.robot
Suite Setup    Customer_material.System Logon
Suite Teardown    Customer_material.System Logout
Test Tags    Customer_material_temp
 
 
*** Test Cases ***
Kellogs_
    Kellogs_