*** Settings ***
Resource    ../Tests/Resource/SMLG_post_ABlNBEV.robot
Suite Setup    SMLG_post_ABlNBEV.System Logon
Suite Teardown    SMLG_post_ABlNBEV.System Logout
Test Tags    SMLG_ABLN_post

*** Test Cases ***
SMLG_ABLN
    SMLG_ABLN
    Delete logon group
    Create logon group