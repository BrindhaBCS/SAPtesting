*** Settings ***
Resource    ../Tests/Resource/ST02_Tcode.robot
Suite Setup    ST02_Tcode.System Logon
Suite Teardown    ST02_Tcode.System Logout
Test Tags    ST02_Tcode_DTA
*** Test Cases ***
ST02_Transation_code
    ST02_Transation_code