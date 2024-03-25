*** Settings ***
Resource    ../Tests/Resource/SE38_REFRESH.robot  
Suite Setup    SE38_REFRESH.System Logon
Suite Teardown    SE38_REFRESH.System Logout
Task Tags    SE38_REFRESH
 
 
*** Test Cases ***
SAP_PROFILE_SE38_T_code
    SAP_PROFILE_SE38_T_code