*** Settings ***
Resource    Resource/SPDD.robot
Force Tags    SPDD
Suite Setup    SPDD.System Logon
Suite Teardown    SPDD.System Logout
  
*** Test Cases ***

Executing SPDD
    Transaction SPDD
