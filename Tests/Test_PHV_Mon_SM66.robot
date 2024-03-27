*** Settings ***
Resource    Resource/PHV_Mon_SM66.robot
Force Tags    PHV_sm66
Suite Setup    PHV_Mon_SM66.System Logon
Suite Teardown    PHV_Mon_SM66.System Logout
  
*** Test Cases ***

Transaction_Code_SM66

    SM66_Transation_code
    