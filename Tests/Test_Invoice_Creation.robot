*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Invoice_Creation.robot
Force Tags    invoice
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
System Logon
    Invoice_Creation.System Logon
Executing Invoice Creation
    Executing Invoice Creation
System Logout
    Invoice_Creation.System Logout    




    

   

    

