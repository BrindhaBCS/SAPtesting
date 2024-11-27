*** Settings ***
Resource    ../Tests/Resource/PVH_SM59.robot
Suite Setup    PVH_SM59.System Logon
Suite Teardown    PVH_SM59.System Logout
Test Tags    pvh_sm59

*** Test Cases ***
PVH_SM59
    PVH_SM59