*** Settings ***
Resource    ../Tests/Resource/SLDAPICUST.robot
Suite Setup    SLDAPICUST.System Logon
Suite Teardown    SLDAPICUST.System Logout 
Test Tags    SLDAPICUST_ST

*** Test Cases ***
SLDAPICUST
    SLDAPICUST