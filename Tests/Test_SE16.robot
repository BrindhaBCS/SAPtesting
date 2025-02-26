*** Settings ***
Resource    ../Tests/Resource/SE16_Olympus.robot
Test Tags    SE16   
Suite Setup    SE16_Olympus.System Logon
Suite Teardown    SE16_Olympus.System Logout
  
*** Test Cases ***
SE16
    SE16
