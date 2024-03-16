*** Settings *
Resource    Resource/SM59.robot
Force Tags    sm59gv
Suite Setup    SM59.SAP Logon
Suite Teardown    SM59.SAP Logout
  
*** Test Cases ***

Executing SM59
    SM59