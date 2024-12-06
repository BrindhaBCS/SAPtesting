*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/PO_Status.robot
Force Tags    po_status
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
System Logon
    PO_Status.System Logon
Executing PO Status
    Executing PO Status
Result
    Result
System Logout
    PO_Status.System Logout    




    

   

    

