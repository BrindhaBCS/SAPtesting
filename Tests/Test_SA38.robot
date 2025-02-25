*** Settings ***
Resource    ../Tests/Resource/SA38_Olympus.robot
Test Tags    SA38   
Suite Setup    SA38_Olympus.System Logon
Suite Teardown    SA38_Olympus.System Logout
  
*** Test Cases ***
SA38
    SA38
