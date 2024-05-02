*** Settings ***
Resource    Resource/SMLG.robot
Force Tags    Migration
Suite Setup    SMLG.System Logon
Suite Teardown    SMLG.System Logout
  
*** Test Cases ***

Executing SMLG
    Transaction SMLG
    SMLG Attributes
    SMLG Load Distributions