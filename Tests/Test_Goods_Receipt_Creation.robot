*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Goods_Receipt_Creation.robot
Force Tags    gr
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
System Logon
    Goods_Receipt_Creation.System Logon
Executing GR Creation
    Executing GR Creation
System Logout
    Goods_Receipt_Creation.System Logout    




    

   

    

