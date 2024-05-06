*** Settings ***
Resource    Resource/Uconcockpit.robot
#Force Tags    Uconcockpit
Suite Setup    Uconcockpit.System Logon
Suite Teardown    Uconcockpit.System Logout
  
*** Test Cases ***

Executing Uconcockpit
    [Tags]    migration
    Transaction Uconcockpit
RFC Basic Scenario
    [Tags]    migration
    RFC Basic Scenario
Role Building Scenario
    [Tags]    migration
    Role Building Scenario
