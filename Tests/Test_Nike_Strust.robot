*** Settings ***
Resource    Resource/Nike_STRUST.robot
Force Tags    Nike_STRUST
Suite Setup    Nike_STRUST.System Logon
Suite Teardown    Nike_STRUST.System Logout
  
*** Test Cases ***

Executing STRUST
    Transaction STRUST
    SSL server standard        
    