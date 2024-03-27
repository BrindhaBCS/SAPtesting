*** Settings ***
Resource    Resource/PHV_Mon_SMQ2.robot
Force Tags    PHV_smq2
Suite Setup   PHV_Mon_SMQ2.System Logon
Suite Teardown    PHV_Mon_SMQ2.System Logout
  
*** Test Cases ***

SMQ2_Transation_code

    SMQ2_Transation_code
    