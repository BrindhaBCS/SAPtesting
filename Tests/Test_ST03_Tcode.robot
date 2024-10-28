*** Settings ***
Resource    ../Tests/Resource/ST03_Tcode.robot
Suite Setup    ST03_Tcode.System Logon
Suite Teardown    ST03_Tcode.System Logout
Test Tags    ST03_Tcode_DTA
*** Test Cases ***
ST03_Tcode
    ST03_Tcode