*** Settings ***
Resource    ../Tests/Resource/SM21_Tcode.robot
Suite Setup    SM21_Tcode.System Logon
Suite Teardown    SM21_Tcode.System Logout
Test Tags    SM21_Tcode_DTA
*** Test Cases ***
SM21_Tcode
    SM21_Tcode