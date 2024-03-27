*** Settings ***
Resource    Resource/PHV_Mon_SM12.robot
Force Tags    PHV_sm12
Suite Setup    PHV_Mon_SM12.System Logon
Suite Teardown    PHV_Mon_SM12.System Logout
  
*** Test Cases ***



SM12_Transation_code

    SM12_Transation_Code