*** Settings ***
Resource    ../Tests/Resource/PVH_ST02.robot
Suite Setup    PVH_ST02.System Logon
Suite Teardown    PVH_ST02.System Logout
Test Tags    pvh_st02

*** Test Cases ***
PVH_ST02
    PVH_ST02
    Create_Images_to_pdf