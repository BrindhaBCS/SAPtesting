*** Settings ***
Resource    ../Tests/Resource/PVH_CheckStatus.robot
Suite Setup    PVH_CheckStatus.System Logon
Suite Teardown    PVH_CheckStatus.System Logout
Test Tags    checkstatus

*** Test Cases ***
CheckStatus
    CheckStatus