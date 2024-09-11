*** Settings ***
Resource    ../Tests/Resource/SM02.robot
Task Tags   SM02
Suite Setup    SM02.System Logon
Suite Teardown    SM02.System Logout
 
*** Test Cases ***
Certificate Validation
    SM02
