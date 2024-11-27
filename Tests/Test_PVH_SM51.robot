*** Settings ***
Resource    ../Tests/Resource/PVH_SM51.robot
Suite Setup    PVH_SM51.System Logon
Suite Teardown    PVH_SM51.System Logout
Test Tags    pvh_sm51

*** Test Cases ***
PVH_SM51
    PVH_SM51