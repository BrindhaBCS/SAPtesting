*** Settings ***
Resource    ../Tests/Resource/STRUSTSSO2_SSL_REFRESH.robot   
Suite Setup    STRUSTSSO2_SSL_REFRESH.System Logon
Suite Teardown    STRUSTSSO2_SSL_REFRESH.System Logout
Task Tags    STRUSTSS02_SSL
 
 
*** Test Cases ***
STRUSTSSO2_SSL
    STRUSTSSO2_SSL
STRUSTSSO2_SSL_System_PSE
    STRUSTSSO2_SSL_System_PSE
STRUSTSSO2_SSL_Sever_Standard 
    STRUSTSSO2_SSL_Sever_Standard 
STRUSTSSO2_SSL client SSL Client Anonymous
    STRUSTSSO2_SSL client SSL Client Anonymous
STRUSTSSO2_SSL client SSL Client Standard
    STRUSTSSO2_SSL client SSL Client Standard