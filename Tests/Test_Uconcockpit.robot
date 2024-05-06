*** Settings ***
Resource    Resource/Uconcockpit.robot
#Force Tags    Uconcockpit
Suite Setup    Uconcockpit.System Logon
Suite Teardown    Uconcockpit.System Logout
  
*** Test Cases ***

Executing Uconcockpit
    [Tags]    Migration
    Transaction Uconcockpit
RFC Basic Scenario
    [Tags]    Migration
    RFC Basic Scenario
Role Building Scenario
    [Tags]    Migration
    Role Building Scenario
