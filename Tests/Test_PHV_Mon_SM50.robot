*** Settings ***
Resource    Resource/PHV_Mon_SM50.robot
Force Tags    PHV_sm50
Suite Setup    PHV_Mon_SM50.System Logon
Suite Teardown    PHV_Mon_SM50.System Logout
  
*** Test Cases ***

Transaction_Code_SM50

    Transaction_Code_SM50
    