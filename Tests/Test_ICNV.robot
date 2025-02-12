*** Settings ***
Resource    ../Tests/Resource/ICNV_Olympus.robot
Test Tags    ICNV_Olympus   
Suite Setup    ICNV_Olympus.System Logon
Suite Teardown    ICNV_Olympus.System Logout
  
*** Test Cases ***
ICNV
    ICNV
