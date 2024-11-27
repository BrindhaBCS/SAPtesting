*** Settings ***
Resource    ../Tests/Resource/PVH_SM13.robot
Suite Setup    PVH_SM13.System Logon
Suite Teardown    PVH_SM13.System Logout
Test Tags    pvh_sm13

*** Test Cases ***
PVH_SM13
    PVH_SM13