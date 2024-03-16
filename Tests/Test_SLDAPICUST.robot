*** Settings *
Resource    Resource/SLDAPICUST.robot
Force Tags    sldapicustgv
Suite Setup    SLDAPICUST.SAP Logon
Suite Teardown    SLDAPICUST.SAP Logout
  
*** Test Cases ***

Executing SLDAPICUST
    Sldapicust