*** Settings ***
Resource    ../Tests/Resource/SMICM_Olympus.robot
Test Tags    SMICM_Olympus   
Suite Setup    SMICM_Olympus.System Logon
Suite Teardown    SMICM_Olympus.System Logout
  
*** Test Cases ***
SMICM
    SMICM
    

