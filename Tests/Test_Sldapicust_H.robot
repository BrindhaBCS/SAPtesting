*** Settings ***
Resource    ../Tests/Resource/Sldapicust_H.robot
Suite Setup    Sldapicust_H.System Logon
Suite Teardown    Sldapicust_H.System Logout
Test Tags    SLDAPICUST_heineken

*** Test Cases ***
SLDAPICUST
    SLDAPICUST