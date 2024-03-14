*** Settings ***
Resource    ../Tests/Resource/SPAD.robot
Suite Setup    SPAD.System Logon
Suite Teardown    SPAD.System Logout 
Test Tags    SPAD_ST

*** Test Cases ***
SPAD
    SPAD