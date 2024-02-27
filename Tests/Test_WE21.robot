*** Settings ***
Resource    Resource/WE21.robot
Force Tags    WE21
Suite Setup    WE21.System Logon
Suite Teardown    WE21.System Logout
  
*** Test Cases ***


Executing WE21 
   
    Transaction WE21
    Transactional RFC
    File Port
    ABAP-PI
    XML File
    XML HTTP