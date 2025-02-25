*** Settings ***
Resource    ../Tests/Resource/DBCO.robot
Test Tags    DBCO.robot   
Suite Setup    DBCO.System Logon
Suite Teardown    DBCO.System Logout
  
*** Test Cases ***
DBCO
    DBCO
