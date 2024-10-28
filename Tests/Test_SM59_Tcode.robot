*** Settings ***
Resource    ../Tests/Resource/SM59_Tcode.robot
Suite Setup    SM59_Tcode.System Logon
Suite Teardown    SM59_Tcode.System Logout
Test Tags    SM59_Tcode_DTA
*** Test Cases ***
SM59_Transation_code
    SM59_Transation_code