*** Settings ***
Resource    ../Tests/Resource/SMQR.robot
Suite Setup    SMQR.System Logon
Suite Teardown    SMQR.System Logout 
Test Tags    SMQR_ST

*** Test Cases ***
SMQR
    SMQR