*** Settings ***
Resource    ../Tests/Resource/STC02_REFRESH.robot 
Suite Setup    STC02_REFRESH.System Logon
Suite Teardown    STC02_REFRESH.System Logout
Task Tags    STC02_REFRESH
 
 
*** Test Cases ***
scenario-STCO2
    scenario-STCO2