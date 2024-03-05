*** Settings ***
Resource    ../Tests/Resource/Database_version_SM51_REFRESH.robot   
Suite Setup    Database_version_SM51_REFRESH.System Logon
Suite Teardown    Database_version_SM51_REFRESH.System Logout
Task Tags    Database_version
 
 
*** Test Cases ***
Database_version_SM51_T_CODE
    Database_version_SM51_T_CODE