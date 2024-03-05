*** Settings ***
Resource    ../Tests/Resource/SM19_SecurityAuditProfile_REFRESH.robot
Suite Setup    SM19_SecurityAuditProfile_REFRESH.System Logon
Suite Teardown    SM19_SecurityAuditProfile_REFRESH.System Logout
Task Tags    SM19_REFRESH
 
 
*** Test Cases ***
scenario-SecurityAuditProfile
    scenario-SecurityAuditProfile