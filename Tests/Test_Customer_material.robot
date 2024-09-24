*** Settings ***
Resource    ../Tests/Resource/Customer_material.robot
Suite Setup    Customer_material.System Logon
Suite Teardown    Customer_material.System Logout
Task Tags    Customer_material_temp
 
 
*** Test Cases ***
Kellogs_
    Kellogs_