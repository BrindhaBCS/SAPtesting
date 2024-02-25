*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/AL11.robot
Force Tags    Al11
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout

  
*** Test Cases ***

Executing AL11
    Transaction AL11