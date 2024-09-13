*** Settings ***
Resource    Resource/STRUST.robot
Force Tags    STRUST
Suite Setup    STRUST.System Logon
Suite Teardown    STRUST.System Logout
  
*** Test Cases ***

Executing STRUST
    Transaction STRUST
    # SSL server standard        
    # SSL client SSL Client (Anonymous)
    # SSL client SSL Client (Standard)  
    # WS Security Other System Encryption   
    SSF Logon Ticket