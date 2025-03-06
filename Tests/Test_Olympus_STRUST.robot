*** Settings ***
Resource    Resource/Olympus_STRUST.robot
Test Tags    STRUST  
*** Test Cases ***

Executing STRUST
    System Logon
    Transaction STRUST
    System pse
    SSL server standard        
    SSL client SSL Client (Anonymous)
    SSL client SSL Client (Standard)    
    SSF Logon Ticket