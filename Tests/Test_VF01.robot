*** Settings ***
Resource    ../Tests/Resource/VF01.robot
Suite Setup    VF01.System Logon
Suite Teardown    VF01.System Logout
Test Tags    salesorder3


*** Test Cases ***
VF01
    VF01