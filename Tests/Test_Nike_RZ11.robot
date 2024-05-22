*** Settings ***
Resource    Resource/Nike_RZ11.robot
Force Tags    Nike_RZ11
Suite Setup    Nike_RZ11.System Logon
Suite Teardown    Nike_RZ11.System Logout
  
*** Test Cases ***

Executing RZ11
    Transaction RZ11
    Parameter check