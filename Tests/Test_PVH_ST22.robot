*** Settings ***
Resource    ../Tests/Resource/PVH_ST22.robot
Suite Setup    PVH_ST22.System Logon
Suite Teardown    PVH_ST22.System Logout
Test Tags    pvh_sT22

*** Test Cases ***
PVH_ST22
    PVH_ST22