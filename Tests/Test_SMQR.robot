*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/SMQR.robot
Force Tags    SMQR
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***



Executing SMQR
    Transaction SMQR