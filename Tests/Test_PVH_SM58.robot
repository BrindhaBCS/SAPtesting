*** Settings ***
Resource    ../Tests/Resource/PVH_SM58.robot
Suite Setup    PVH_SM58.System Logon
Suite Teardown    PVH_SM58.System Logout
Test Tags    pvh_sm58

*** Test Cases ***
PVH_SM58
    PVH_SM58