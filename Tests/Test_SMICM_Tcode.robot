*** Settings ***
Resource    ../Tests/Resource/SMICM_Tcode.robot
Suite Setup    SMICM_Tcode.System Logon
Suite Teardown    SMICM_Tcode.System Logout
Test Tags    SMICM_Tcode_DTA
*** Test Cases ***
SMICM_Tcode
    SMICM_Tcode