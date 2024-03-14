*** Settings ***
Resource    ../Tests/Resource/SE03.robot
Suite Setup    SE03.System Logon
Suite Teardown    SE03.System Logout 
Test Tags    SE03_ST

*** Test Cases ***
SE03
    SE03
