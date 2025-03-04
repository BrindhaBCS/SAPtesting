*** Settings ***
Resource    ../Tests/Resource/Slicense_H.robot
Suite Setup    Slicense_H.System Logon
Suite Teardown    Slicense_H.System Logout
Test Tags    SLICENSE_heineken

*** Test Cases ***

SLICENSE 
    SLICENSE