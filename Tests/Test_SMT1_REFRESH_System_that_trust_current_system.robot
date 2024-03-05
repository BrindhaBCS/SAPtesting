*** Settings ***
Resource    ../Tests/Resource/SMT1_REFRESH_System_that_trust_current_system.robot
Suite Setup    SMT1_REFRESH_System_that_trust_current_system.System Logon
Suite Teardown    SMT1_REFRESH_System_that_trust_current_system.System Logout
Task Tags    SMT1_REFRESH
*** Test Cases ***
SMT1_T_CODE_System_that_trust_current_system
    SMT1_T_CODE_System_that_trust_current_system