*** Settings ***
Resource    ../Tests/Resource/SPNEGO.robot
Suite Setup    SPNEGO.System Logon
Suite Teardown    SPNEGO.System Logout 
Test Tags    SPNEGO_ST

*** Test Cases ***
SPNEGO
    SPNEGO