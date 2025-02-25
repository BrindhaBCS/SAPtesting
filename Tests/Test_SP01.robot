*** Settings ***
Resource    ../Tests/Resource/SP01_Olympus.robot
Test Tags    SP01   
Suite Setup    SP01_Olympus.System Logon
Suite Teardown    SP01_Olympus.System Logout
  
*** Test Cases ***
SP01
    SP01
