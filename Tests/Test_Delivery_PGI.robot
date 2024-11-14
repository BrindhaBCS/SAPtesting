*** Settings ***
Resource    ../Tests/Resource/Delivery_Post_Goods_Issue.robot
Test Tags    Delivery_Post_Goods_Issue
Suite Setup    Delivery_Post_Goods_Issue.System Logon
Suite Teardown    Delivery_Post_Goods_Issue.System Logout
  
*** Test Cases ***
Delivery_Post_Goods_Issue
    Delivery_Post_Goods_Issue