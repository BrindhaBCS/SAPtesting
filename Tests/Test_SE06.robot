*** Settings ***
Resource    ../Tests/Resource/SE06.robot
Suite Setup    SE06.System Logon
Suite Teardown    SE06.System Logout 
Test Tags    SE06_ST

*** Test Cases ***
SE06
    SE06
