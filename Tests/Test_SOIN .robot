*** Settings ***
Resource    ../Tests/Resource/SOIN_Olympus.robot
Test Tags    SOIN   
Suite Setup    SOIN_Olympus.System Logon
Suite Teardown    SOIN_Olympus.System Logout
  
*** Test Cases ***
SOIN
    SOIN
