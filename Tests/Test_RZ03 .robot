*** Settings ***
Resource    ../Tests/Resource/RZ03 .robot
Test Tags    RZ03   
Suite Setup    RZ03.System Logon
Suite Teardown    RZ03.System Logout
  
*** Test Cases ***
RZ03
    RZ03
