*** Settings ***
Resource    Resource/PHV_Mon_SM13.robot
Force Tags    PHV_sm13
Suite Setup   PHV_Mon_SM13.System Logon
Suite Teardown    PHV_Mon_SM13.System Logout
  
*** Test Cases ***

SM13_Transation_code

    SM13_Transation_code