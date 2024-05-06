*** Settings ***
Resource    Resource/STMS.robot
#Force Tags    STMS
Suite Setup    STMS.System Logon
Suite Teardown    STMS.System Logout
  
*** Test Cases ***

     
Executing STMS
    [Tags]    migration
    Transaction STMS  
Import Overview
    [Tags]    migration
    Import Overview    
Transport Routes
    [Tags]    migration
    Transport Routes  
Transport Layers
    [Tags]    migration
    Transport Layers
