*** Settings ***
Resource    ../Tests/Resource/ERS_Verification.robot
Test Tags    ERS_Verification
Suite Setup    ERS_Verification.System Logon
Suite Teardown    ERS_Verification.System Logout
  
*** Test Cases ***

ERS_Verification
    ERS_Verification
