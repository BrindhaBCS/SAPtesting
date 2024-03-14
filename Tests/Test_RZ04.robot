*** Settings ***
Resource    ../Tests/Resource/RZ04.robot
Suite Setup    RZ04.System Logon
Suite Teardown    RZ04.System Logout 
Test Tags    RZ04_ST

*** Test Cases ***
RZ04
    RZ04