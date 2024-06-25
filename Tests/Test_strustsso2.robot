*** Settings ***
Resource    Resource/strustsso2.robot
Test Tags   strustsso2
Suite Setup    strustsso2.System Logon
Suite Teardown    strustsso2.System Logout
  
*** Test Cases ***

Executing Strustsso2
    Transaction STRUST
    SSL server standard        
    