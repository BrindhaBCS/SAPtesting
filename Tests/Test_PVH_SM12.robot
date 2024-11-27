*** Settings ***
Resource    ../Tests/Resource/PVH_SM12.robot
Suite Setup    PVH_SM12.System Logon
Suite Teardown    PVH_SM12.System Logout
Test Tags    pvh_sm12

*** Test Cases ***
PVH_SM12
    PVH_SM12