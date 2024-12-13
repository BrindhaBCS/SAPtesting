*** Settings ***
Resource    ../Tests/Resource/SMLG_pre_ABLNBEV.robot
Suite Setup    SMLG_pre_ABLNBEV.System Logon
Suite Teardown    SMLG_pre_ABLNBEV.System Logout
Test Tags    SMLG_ABLN

*** Test Cases ***
SMLG_ABLN
    SMLG_ABLN