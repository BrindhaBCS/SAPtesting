*** Settings ***
Resource    Resource/Uconcockpit.robot
Force Tags    Migration
Suite Setup    Uconcockpit.System Logon
Suite Teardown    Uconcockpit.System Logout
  
*** Test Cases ***

Executing Uconcockpit
    Transaction Uconcockpit
    RFC Basic Scenario
    Role Building Scenario