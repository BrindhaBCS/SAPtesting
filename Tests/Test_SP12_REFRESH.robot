*** Settings ***
Resource    ../Tests/Resource/SP12_REFRESH.robot
Suite Setup    SP12_REFRESH.System Logon
Suite Teardown    SP12_REFRESH.System Logout
Task Tags    SP12_REFRESH
 
 
*** Test Cases ***
SP12
    SP12