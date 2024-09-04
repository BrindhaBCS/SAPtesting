*** Settings ***
Resource    ../Tests/Resource/SM02_MESSAGE.robot
Suite Setup    SM02_MESSAGE.System Logon
Suite Teardown    SM02_MESSAGE.System Logout
Test Tags    systemmessage


*** Test Cases ***
SM02
    SM02