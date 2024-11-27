*** Settings ***
Resource    ../Tests/Resource/PVH_SM21.robot
Suite Setup    PVH_SM21.System Logon
Suite Teardown    PVH_SM21.System Logout
Test Tags    pvh_sm21

*** Test Cases ***
PVH_SM21
    PVH_SM21