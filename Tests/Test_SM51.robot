*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/SM51.robot
Force Tags    SM51
Suite Setup    SM51.System Logon
Suite Teardown    SM51.System Logout


*** Test Cases ***
Executing SM51
    Transaction SM51
    