*** Settings ***
Resource    ../Tests/Resource/SMLG_post_Abinbev.robot
Suite Setup    SMLG_post_Abinbev.System Logon
Suite Teardown    SMLG_post_Abinbev.System Logout
Test Tags    SMLG_ABIN_post

*** Test Cases ***
SMLG_ABLN
    SMLG_ABLN
    Delete logon group
    Create logon group