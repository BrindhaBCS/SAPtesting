*** Settings ***
Resource    ../Tests/Resource/SMLG_post_ABINBEV.robot
Suite Setup    SMLG_post_ABINBEV.System Logon
Suite Teardown    SMLG_post_ABINBEV.System Logout
Test Tags    SMLG_ABIN_post

*** Test Cases ***
SMLG_ABLN
    SMLG_ABLN
    Delete logon group
    Create logon group