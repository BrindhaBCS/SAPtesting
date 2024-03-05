*** Settings ***
Resource    ../Tests/Resource/SOAMANAGER_REFRESH.robot
Suite Setup    SOAMANAGER_REFRESH.System Logon
Suite Teardown    SOAMANAGER_REFRESH.System Logout
Task Tags    SOAMANAGER_REFRESH
 
 
*** Test Cases ***
SOAMANAGER
    SOAMANAGER