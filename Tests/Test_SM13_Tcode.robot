*** Settings ***
Resource    ../Tests/Resource/SM13_Tcode.robot
Suite Setup    SM13_Tcode.System Logon
Suite Teardown    SM13_Tcode.System Logout
Test Tags    SM13_Tcode_DTA
*** Test Cases ***
SM13_Transation_code
    SM13_Transation_code