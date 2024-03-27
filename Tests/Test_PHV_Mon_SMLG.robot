*** Settings ***
Resource    Resource/PHV_Mon_SMLG.robot
Force Tags    PHV_smlg
Suite Setup    PHV_Mon_SMLG.System Logon
Suite Teardown    PHV_Mon_SMLG.System Logout
  
*** Test Cases ***

SMLG_Transation_Code

    SMLG_Transation_Code