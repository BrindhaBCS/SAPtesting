*** Settings ***
Resource    ../Tests/Resource/license checking.robot
Suite Setup    license checking.System Logon
Suite Teardown   license checking.System Logout
Test Tags    license_checking

*** Test Cases ***
license checking
    license checking