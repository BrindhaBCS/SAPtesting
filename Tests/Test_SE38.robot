*** Settings ***
Resource    ../Tests/Resource/SE38.robot
Test Tags    se38_heineken
Suite Setup   SE38.System Logon
Suite Teardown   SE38.System Logout

*** Test Cases ***
SE38
    SE38