*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/STRUST.robot
Force Tags    STRUST
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***

Executing STRUST
    Transaction STRUST
    SSL server standard        
    SSL client SSL Client (Anonymous)
    SSL client SSL Client (Standard)  
    WS Security Other System Encryption   
    SSF Logon Ticket