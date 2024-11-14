*** Settings ***
Resource    ../Tests/Resource/Multi_SalesOrderCreation.robot
Test Tags    Multi_SalesOrderCreation
Suite Setup    Multi_SalesOrderCreation.System Logon
Suite Teardown    Multi_SalesOrderCreation.System Logout
  
*** Test Cases ***
SalesOrderCreation
    SalesOrderCreation
