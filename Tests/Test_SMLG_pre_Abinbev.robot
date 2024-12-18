*** Settings ***
Resource    ../Tests/Resource/SMLG_pre_Abinbev.robot
Suite Setup    SMLG_pre_Abinbev.System Logon
Suite Teardown    SMLG_pre_Abinbev.System Logout
Test Tags    SMLG_ABIN

*** Test Cases ***
SMLG_ABLN
    SMLG_ABLN