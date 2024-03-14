*** Settings ***
Resource    ../Tests/Resource/SMQS.robot
Suite Setup    SMQS.System Logon
Suite Teardown    SMQS.System Logout 
Test Tags    SMQS_ST

*** Test Cases ***
SMQS
    SMQS