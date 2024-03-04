*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/DB02.robot
Force Tags    DB02
Suite Setup    DB02.System Logon
Suite Teardown    DB02.System Logout


*** Test Cases ***
Executing DB02
    Transaction DB02