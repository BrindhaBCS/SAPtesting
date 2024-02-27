*** Settings *
Resource    Resource/SLDAPICUST.robot
Force Tags    SLDAPICUST
Suite Setup    SLDAPICUST.System Logon
Suite Teardown    SLDAPICUST.System Logout
  
*** Test Cases ***

Executing SLDAPICUST

    Transaction SLDAPICUST
    Sldapicust display  