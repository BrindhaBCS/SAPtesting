*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/OACA.robot
Force Tags    OAC0
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***

Executing OACO    
    Transaction OACO