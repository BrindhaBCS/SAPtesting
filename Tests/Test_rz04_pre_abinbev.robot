*** Settings ***
Resource    ../Tests/Resource/rz04_pre_abinbev.robot
Suite Setup   rz04_pre_abinbev.System Logon
Suite Teardown    rz04_pre_abinbev.System Logout
Test Tags    rz04_ABLN

*** Test Cases ***
rz04_ABLN
    rz04_ABLN
    Daymode
    Nightmode