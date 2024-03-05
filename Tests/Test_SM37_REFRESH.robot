*** Settings ***
Resource    ../Tests/Resource/SM37_REFRESH.robot
Suite Setup    SM37_REFRESH.System Logon
Suite Teardown    SM37_REFRESH.System Logout
Task Tags    SM37_REFRESH
 
 
*** Test Cases ***
SM37
    SM37