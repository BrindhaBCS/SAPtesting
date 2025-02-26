*** Settings ***
Resource    ../Tests/Resource/Sldcheck_Olympus.robot
Test Tags    Sldcheck   
Suite Setup    Sldcheck_Olympus.System Logon
Suite Teardown    Sldcheck_Olympus.System Logout
  
*** Test Cases ***
Sldcheck
    Sldcheck
