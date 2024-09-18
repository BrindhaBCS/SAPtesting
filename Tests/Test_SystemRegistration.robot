*** Settings ***
Resource    ../Tests/Resource/SystemRegistration.robot
Force Tags    Sys_Reg
Suite Setup    System Registration.System Logon
Suite Teardown    System Registration.System Logout
  
*** Test Cases ***
System Registration
    System Registration