*** Settings ***
Resource    ../Tests/Resource/Customer_material.robot
Resource    ../Tests/Resource/Customer_material_2.robot
# Suite Setup    Customer_material.System Logon
# Suite Teardown    Customer_material.System Logout
# Test Tags    Customer_material_temp
 
 
*** Test Cases ***
Kellogs_
    [Tags]    Customer_material_temp
    [Setup]    Customer_material.System Logon
    Kellogs_
    [Teardown]    Customer_material.System Logout
Kellogs_2
    [Tags]    Customer_material_2
    [Setup]    Customer_material_2.System Logon
    Kellogs_2
    [Teardown]    Customer_material_2.System Logout