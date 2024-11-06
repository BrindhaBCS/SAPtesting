*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Purchase_Order_Creation.robot
Force Tags    po
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
System Logon
    Purchase_Order_Creation.System Logon
Executing PO Creation
    Executing PO Creation
System Logout
    Purchase_Order_Creation.System Logout    




    

   

    

