*** Settings ***
Resource    ../Tests/Resource/smqs.robot
Suite Setup    smqs.SAP Logonn
Suite Teardown    smqs.System Logout
Test Tags    smqSS

*** Test Cases ***
smqs
    SMQS_tcodes
smq1
    SMQ1_tcodes
    