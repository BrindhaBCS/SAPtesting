
*** Settings ***

Resource    ../Tests/Resource/Create_Sales_Orders.robot
Force Tags    Create_Sales_Orders
Suite Setup    Create_Sales_Orders.System Logon
Suite Teardown    Create_Sales_Orders.System Logout
  
*** Test Cases ***
Executing VA01
    Generate and Use Random Number
    Transaction VA01
    Selecting multiple materials
    Save Document
    