*** Settings ***
Resource    ../Tests/Resource/SM37_Tcode.robot
Suite Setup    SM37_Tcode.System Logon
Suite Teardown    SM37_Tcode.System Logout
Test Tags    SM37_Tcode_DTA
*** Test Cases ***
SM37_Tcode
    SM37_Tcode