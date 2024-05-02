*** Settings ***
Resource    Resource/SHMM.robot
Force Tags    Migration
Suite Setup    SHMM.System Logon
Suite Teardown    SHMM.System Logout
  
*** Test Cases ***


Executing SHMM
    Transaction SHMM