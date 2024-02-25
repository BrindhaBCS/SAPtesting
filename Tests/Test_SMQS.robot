*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/SMQS.robot
Force Tags    SMQS
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout

*** Test Cases ***

Executing SMQS

    Transaction SMQS
    QRFC Administration     
    QRFC Administration INBOUND
    QRFC Administration OUTBOUND
    QRFC Administration OUTBOUND SCHEDULER
    QRFC Administration INBOUND SCHEDULER
    Display Possible Resources