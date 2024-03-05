*** Settings ***
Resource    ../Tests/Resource/SM30_REFRESH.robot
Suite Setup    SM30_REFRESH.System Logon
Suite Teardown    SM30_REFRESH.System Logout
Task Tags    SM30_REFRESH
 
 
*** Test Cases ***
SM30
    SM30