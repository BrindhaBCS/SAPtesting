*** Settings ***
Resource    ../Tests/Resource/SM20_securityauditAnalysis_REFRESH.robot
Suite Setup    SM20_securityauditAnalysis_REFRESH.System Logon
Suite Teardown    SM20_securityauditAnalysis_REFRESH.System Logout
Task Tags    SM20_REFRESH
 
 
*** Test Cases ***
scenario-securityauditAnalysis
    scenario-securityauditAnalysis