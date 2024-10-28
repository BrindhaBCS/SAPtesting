*** Settings ***
Resource    ../Tests/Resource/ST22_Tcode.robot
Suite Setup    ST22_Tcode.System Logon
Suite Teardown    ST22_Tcode.System Logout
Test Tags    ST22_Tcode_DTA
*** Test Cases ***
ST22_Transation_code
    ST22_Transation_code