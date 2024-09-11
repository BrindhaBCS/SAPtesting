*** Settings ***
Resource    ../Tests/Resource/WE20_REFRESH.robot   
Suite Setup    WE20_REFRESH.System Logon
Suite Teardown    WE20_REFRESH.System Logout
Task Tags    WE20_REFRESH
 
 
*** Test Cases ***
WE20_T_CODE
    WE20_T_CODE
Partner type KU
    Partner type KU
Partner type LS
    Partner type LS
Partner type LI
    Partner type LI
