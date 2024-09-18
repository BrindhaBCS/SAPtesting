*** Settings ***
Resource    ../Tests/Resource/DeActivateUser.robot
Suite Setup    DeActivateUser.System Logon
Suite Teardown    DeActivateUser.System Logout
Test Tags    DeActivateUser

*** Test Cases ***
DeActivate User
    DeActivate User