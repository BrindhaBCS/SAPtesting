*** Settings ***
Resource    ../Tests/Resource/SUIM.robot
# Suite Setup   SUIM.SAP Logonn
# Suite Teardown    SUIM.LOGOUT
Test Tags    SUIM

*** Test Cases ***
SAP Logonn
    SAP Logonn
# USMM
#     USMM
# EMERGENCY
#     Emergency User Edition
DELETE_AUDIT_FILES
    DELETE_AUDIT_FILES
SUIM
    SUIM
logout
    LOGOUT
