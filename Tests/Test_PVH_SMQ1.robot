*** Settings ***
Resource    ../Tests/Resource/PVH_SMQ1.robot
Suite Setup    PVH_SMQ1.System Logon
Suite Teardown    PVH_SMQ1.System Logout
Test Tags    pvh_smq1

*** Test Cases ***
PVH_SMQ1
    PVH_SMQ1