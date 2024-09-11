*** Settings ***
Resource    ../Tests/Resource/WE21_REFRESH.robot   
Suite Setup    WE21_REFRESH.System Logon
Suite Teardown    WE21_REFRESH.System Logout
Task Tags    WE21_REFRESH
 
 
*** Test Cases ***
WE21_T_CODE
    WE21_T_CODE
XML File
    XML File
XML HTTP
    XML HTTP
