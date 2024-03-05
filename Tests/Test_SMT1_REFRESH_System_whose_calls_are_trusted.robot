*** Settings ***
Resource    ../Tests/Resource/SMT1_REFRESH_System_whose_calls_are_trusted.robot
Suite Setup    SMT1_REFRESH_System_whose_calls_are_trusted.System Logon
Suite Teardown    SMT1_REFRESH_System_whose_calls_are_trusted.System Logout
Task Tags    SMT1_REFRESH1
 
 
*** Test Cases ***
SMT1_T_CODE_System_whose_calls_are_trusted
    SMT1_T_CODE_System_whose_calls_are_trusted
