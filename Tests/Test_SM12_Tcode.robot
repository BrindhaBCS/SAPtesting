*** Settings ***
Resource    ../Tests/Resource/SM12_Tcode.robot
Suite Setup    SM12_Tcode.System Logon
Suite Teardown    SM12_Tcode.System Logout
Test Tags    SM12_Tcode_DTA
*** Test Cases ***
SM12_TRANSATION_CODE
    SM12_TRANSATION_CODE