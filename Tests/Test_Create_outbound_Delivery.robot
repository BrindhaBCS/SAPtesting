
*** Settings ***
Resource    ../Tests/Resource/Create_outbound_Delivery.robot
Force Tags    Create_outbound_Delivery
Suite Setup    Create_outbound_Delivery.System Logon
Suite Teardown    Create_outbound_Delivery.System Logout

  
*** Test Cases ***
Executing VL01N
    Transaction VL01N
    