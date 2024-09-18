*** Settings ***
Resource    ../Tests/Resource/UserCreation.robot
Suite Setup    UserCreation.System Logon
Suite Teardown    UserCreation.System Logout
Test Tags    UserCreation

*** Test Cases ***
Create User
    Create User