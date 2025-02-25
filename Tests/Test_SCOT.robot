*** Settings ***
Resource    ../Tests/Resource/SCOT_Olympus.robot
Test Tags    SCOT   
Suite Setup    SCOT_Olympus.System Logon
Suite Teardown    SCOT_Olympus.System Logout
  
*** Test Cases ***
SCOT
    SCOT
