*** Settings ***
Resource    ../Tests/Resource/SM51_Tcode.robot
Suite Setup    SM51_Tcode.System Logon
Suite Teardown    SM51_Tcode.System Logout
Test Tags    SM51_Tcode_DTA
*** Test Cases ***
SM51_Tcode
    SM51_Tcode