*** Settings ***
Resource    ../Tests/Resource/DB12_Tcode.robot
Suite Setup    DB12_Tcode.System Logon
Suite Teardown    DB12_Tcode.System Logout
Test Tags    DB12_Tcode_DTA
*** Test Cases ***
DB12_Tcode
    DB12_Tcode