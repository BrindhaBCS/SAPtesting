*** Settings ***
Resource    Resource/SMQS.robot
Force Tags    SMQS
Suite Setup    SMQS.System Logon
Suite Teardown    SMQS.System Logout

*** Test Cases ***

Executing SMQS

    Transaction SMQS
    QRFC Administration     
    QRFC Administration INBOUND
    QRFC Administration OUTBOUND
    QRFC Administration OUTBOUND SCHEDULER
    QRFC Administration INBOUND SCHEDULER
    Display Possible Resources