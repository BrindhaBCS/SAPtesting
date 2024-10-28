*** Settings ***
Resource    ../Tests/Resource/ST04_Tcode.robot
Suite Setup    ST04_Tcode.System Logon
Suite Teardown    ST04_Tcode.System Logout
Test Tags    ST04_Tcode_DTA
*** Test Cases ***
ST04_Transation_code
    ST04_Transation_code