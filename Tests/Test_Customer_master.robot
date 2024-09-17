*** Settings ***
Resource    ../Tests/Resource/Customer_master.robot 
Suite Setup    Customer_master.System Logon
Suite Teardown    Customer_master.System Logout
Task Tags    Customer_master_temp
 
 
*** Test Cases ***
Kellogs_
    Kellogs_