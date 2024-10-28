*** Settings ***
Resource    ../Tests/Resource/SM58_Tcode.robot
Suite Setup    SM58_Tcode.System Logon
Suite Teardown    SM58_Tcode.System Logout
Test Tags    SM58_Tcode_DTA
*** Test Cases ***
SM58_Transation_code
    SM58_Transation_code