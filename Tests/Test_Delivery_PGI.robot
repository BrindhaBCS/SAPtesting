*** Settings ***
Resource    ../Tests/Resource/Delivery_Post_Goods_Issue.robot
Test Tags    Delivery_Post_Goods_Issue
# Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
System Logon
    System Logon
Delivery_Post_Goods_Issue
    Delivery_Post_Goods_Issue
# System Logout
    # System Logout