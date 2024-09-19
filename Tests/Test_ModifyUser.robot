*** Settings ***
Resource    ../Tests/Resource/ModifyUser.robot
Suite Setup    ModifyUser.System Logon
Suite Teardown    ModifyUser.System Logout
Test Tags    ModifyUser

*** Test Cases ***
Modify User
    Modify User
    