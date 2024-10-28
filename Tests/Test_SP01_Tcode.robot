*** Settings ***
Resource    ../Tests/Resource/SP01_Tcode.robot
Suite Setup    SP01_Tcode.System Logon
Suite Teardown    SP01_Tcode.System Logout
Test Tags    SP01_Tcode_DTA
*** Test Cases ***
SP01_Tcode
    SP01_Tcode