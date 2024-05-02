*** Settings ***
Resource    Resource/SMQR.robot
Force Tags    Migration
Suite Setup    SMQR.System Logon
Suite Teardown    SMQR.System Logout
  
*** Test Cases ***



Executing SMQR
    Transaction SMQR