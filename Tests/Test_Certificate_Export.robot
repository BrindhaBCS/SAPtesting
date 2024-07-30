*** Settings ***
Resource    ../Tests/Resource/Certificate_Export.robot
Suite Setup    Certificate_Export.System Logon
Suite Teardown    Certificate_Export.System Logout
Test Tags   strustsso2_CPI
  
*** Test Cases ***
Executing Strustsso2
    Transaction STRUST
    SSL server standard        
    