*** Settings ***
Resource    ../Tests/Resource/Strust_Tcode.robot
Suite Setup    Strust_Tcode.System Logon
Suite Teardown    Strust_Tcode.System Logout
Test Tags    Strust_Tcode_DTA
*** Test Cases ***
Strust_Tcode
    Strust_Tcode