*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/SPAD.robot
Force Tags    SPAD
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***

Executing SPAD  
    Transaction SPAD
    ARCH Screenshot    
    LOCL Screenshot    
    LP01 Screenshot   
    ZPDF Screenshot
