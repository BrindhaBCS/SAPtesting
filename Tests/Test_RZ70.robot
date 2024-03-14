*** Settings ***
Resource    ../Tests/Resource/RZ70.robot
Suite Setup    RZ70.System Logon
Suite Teardown    RZ70.System Logout 
Test Tags    RZ70_ST

*** Test Cases ***
RZ70
    RZ70