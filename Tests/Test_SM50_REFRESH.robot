*** Settings ***
Resource    ../Tests/Resource/SM50_REFRESH.robot   
Suite Setup    SM50_REFRESH.System Logon
Suite Teardown    SM50_REFRESH.System Logout
Task Tags    SM50_REFRESH

*** Test Cases ***
SM50_T_CODE
    SM50_T_CODE
    