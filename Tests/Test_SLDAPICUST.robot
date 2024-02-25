*** Settings *
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/SLDAPICUST.robot
Force Tags    SLDAPICUST
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***

Executing SLDAPICUST

    Transaction SLDAPICUST
    Sldapicust display  