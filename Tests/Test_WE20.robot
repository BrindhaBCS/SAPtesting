*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/WE20.robot
Force Tags    WE20
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***

Executing WE20

    Transaction WE20
    Partner type LS
    Partner type LI