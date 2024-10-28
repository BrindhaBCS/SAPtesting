*** Settings ***
Resource    ../Tests/Resource/SM66_Tcode.robot
Suite Setup    SM66_Tcode.System Logon
Suite Teardown    SM66_Tcode.System Logout
Test Tags    SM66_Tcode_DTA
*** Test Cases ***
SM66_Tcode
    SM66_Tcode