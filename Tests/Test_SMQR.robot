*** Settings ***
Resource    Resource/SMQR.robot
Force Tags    SMQR
Suite Setup    SMQR.System Logon
Suite Teardown    SMQR.System Logout
  
*** Test Cases ***



Executing SMQR
    Transaction SMQR