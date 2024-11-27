*** Settings ***
Resource    ../Tests/Resource/PVH_SCC4.robot
Suite Setup    PVH_SCC4.System Logon
Suite Teardown    PVH_SCC4.System Logout
Test Tags    pvh_scc4

*** Test Cases ***
PVH_SCC4
    PVH_SCC4