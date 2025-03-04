*** Settings ***
Resource    ../Tests/Resource/SM37_H.robot
Test Tags    sm37_heineken
Suite Setup   SM37_H.System Logon
Suite Teardown   SM37_H.System Logout

*** Test Cases ***
SM37
    SM37