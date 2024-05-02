*** Settings ***
Resource    ../Tests/Resource/OAC0.robot
Force Tags    Migration
Suite Setup    OAC0.System Logon
Suite Teardown    OAC0.System Logout
  
*** Test Cases ***

Executing OACO    
    Transaction OACO