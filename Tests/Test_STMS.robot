*** Settings ***
Resource    Resource/STMS.robot
Force Tags    STMS
Suite Setup    STMS.System Logon
Suite Teardown    STMS.System Logout
  
*** Test Cases ***
    
Executing STMS
    Transaction STMS  
    Import Overview    
    Transport Routes  
    Transport Layers
