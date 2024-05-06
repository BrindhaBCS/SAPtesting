*** Settings ***
Resource    Resource/STMS.robot
#Force Tags    STMS
Suite Setup    STMS.System Logon
Suite Teardown    STMS.System Logout
  
*** Test Cases ***

     
Executing STMS
    [Tags]    Migration
    Transaction STMS  
Import Overview
    [Tags]    Migration
    Import Overview    
Transport Routes
    [Tags]    Migration
    Transport Routes  
Transport Layers
    [Tags]    Migration
    Transport Layers
