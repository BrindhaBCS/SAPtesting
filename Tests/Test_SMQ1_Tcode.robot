*** Settings ***
Resource    ../Tests/Resource/SMQ1_Tcode.robot
Suite Setup    SMQ1_Tcode.System Logon
Suite Teardown    SMQ1_Tcode.System Logout
Test Tags    SMQ1_Tcode_DTA
*** Test Cases ***
SMQ1_Tcode
    SMQ1_Tcode