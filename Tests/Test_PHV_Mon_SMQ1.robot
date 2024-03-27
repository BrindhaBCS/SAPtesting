*** Settings ***
Resource    Resource/PHV_Mon_SMQ1.robot
Force Tags    PHV_smq1
Suite Setup    PHV_Mon_SMQ1.System Logon
Suite Teardown    PHV_Mon_SMQ1.System Logout
  
*** Test Cases ***

SMQ1_Transation_code

    SMQ1_Transation_code    