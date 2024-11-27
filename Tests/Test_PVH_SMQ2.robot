*** Settings ***
Resource    ../Tests/Resource/PVH_SMQ2.robot
Suite Setup    PVH_SMQ2.System Logon
Suite Teardown    PVH_SMQ2.System Logout
Test Tags    pvh_smq2

*** Test Cases ***
PVH_SMQ2
    PVH_SMQ2