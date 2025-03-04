*** Settings ***
Resource    ../Tests/Resource/SE16.robot
Test Tags    se16_heineken
Suite Setup   SE16.System Logon
Suite Teardown   SE16.System Logout

*** Test Cases ***
SE16
    SE16