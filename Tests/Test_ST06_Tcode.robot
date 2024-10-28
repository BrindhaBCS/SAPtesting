*** Settings ***
Resource    ../Tests/Resource/ST06_Tcode.robot
Suite Setup    ST06_Tcode.System Logon
Suite Teardown    ST06_Tcode.System Logout
Test Tags    ST06_Tcode_DTA
*** Test Cases ***
ST06_Tcode
    ST06_Tcode