*** Settings ***
Resource    Resource/WE20.robot
Force Tags    Migration
Suite Setup    WE20.System Logon
Suite Teardown    WE20.System Logout
  
*** Test Cases ***

Executing WE20

    Transaction WE20
    Partner type LS
    Partner type LI