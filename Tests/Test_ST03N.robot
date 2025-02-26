*** Settings ***
Resource    ../Tests/Resource/ST03N_Olympus.robot
Test Tags    ST03N   
Suite Setup    ST03N_Olympus.System Logon
Suite Teardown    ST03N_Olympus.System Logout
  
*** Test Cases ***
ST03N
    ST03N
