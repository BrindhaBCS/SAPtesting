*** Settings ***
Resource    ../Tests/Resource/Multi_SalesOrderCreation.robot
Test Tags    Multi_SalesOrderCreation
# Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
System Logon
    System Logon
SalesOrderCreation
    SalesOrderCreation
# System Logout
#     System Logout