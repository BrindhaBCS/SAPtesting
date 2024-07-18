*** Settings ***
Resource    ../Tests/Resource/Sales.robot
Suite Setup    Sales.System Logon
Suite Teardown    Sales.System Logout
Task Tags    sales
 
 
*** Test Cases ***
Getting the pending payments list
    pending payments