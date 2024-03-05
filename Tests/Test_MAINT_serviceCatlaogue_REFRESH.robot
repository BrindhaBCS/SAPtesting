*** Settings ***
Resource    ../Tests/Resource/MAINT_serviceCatlaogue_REFRESH.robot  
Suite Setup    MAINT_serviceCatlaogue_REFRESH.System Logon
Suite Teardown    MAINT_serviceCatlaogue_REFRESH.System Logout
Task Tags    Maint_REFRESH
 
 
*** Test Cases ***
scenario-serviceCatlaogue
    scenario-serviceCatlaogue
    
