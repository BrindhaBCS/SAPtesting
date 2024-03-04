*** Settings ***
Resource    Resource/SHMM.robot
Force Tags    SHMM
Suite Setup    SHMM.System Logon
Suite Teardown    SHMM.System Logout
  
*** Test Cases ***


Executing SHMM
    Transaction SHMM