*** Settings ***
Resource    ../Tests/Resource/STRUST.robot
Suite Setup    STRUST.System Logon
Suite Teardown    STRUST.System Logout 
Test Tags    STRUSTSSO2_ST

*** Test Cases ***
STRUSTSSO2
    STRUSTSSO2