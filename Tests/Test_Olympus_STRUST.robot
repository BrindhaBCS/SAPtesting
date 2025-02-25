*** Settings ***
Resource    Resource/Olympus_STRUST.robot
Test Tags    STRUST  
*** Test Cases ***

Executing STRUST
    System Logon
    Transaction STRUST
    SSL server standard        
    SSL client SSL Client (Anonymous)
    SSL client SSL Client (Standard)  
    WS Security Other System Encryption   
    SSF Logon Ticket