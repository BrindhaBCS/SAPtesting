*** Settings ***
Resource    Resource/PHV_Mon_SM51.robot
Force Tags    PHV_sm51
Suite Setup    PHV_Mon_SM51.System Logon
Suite Teardown    PHV_Mon_SM51.System Logout
  
*** Test Cases ***

Transaction_Code_SM51

    Transaction_Code_SM51
    