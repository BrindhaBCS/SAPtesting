*** Settings ***
Resource    ../Tests/Resource/PVH_SMLG.robot
Suite Setup    PVH_SMLG.System Logon
Suite Teardown    PVH_SMLG.System Logout
Test Tags    pvh_smlg

*** Test Cases ***
PVH_SMLG
    PVH_SMLG