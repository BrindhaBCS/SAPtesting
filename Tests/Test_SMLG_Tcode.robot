*** Settings ***
Resource    ../Tests/Resource/SMLG_Tcode.robot
Suite Setup    SMLG_Tcode.System Logon
Suite Teardown    SMLG_Tcode.System Logout
Test Tags    SMLG_Tcode_DTA
*** Test Cases ***
SMLG_Tcode
    SMLG_Transation_code