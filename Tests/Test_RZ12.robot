*** Settings ***
Resource    ../Tests/Resource/RZ12.robot
Suite Setup    RZ12.System Logon
Suite Teardown    RZ12.System Logout 
Test Tags    RZ12_ST

*** Test Cases ***
RZ12
    RZ12