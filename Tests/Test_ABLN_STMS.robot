*** Settings ***
Resource    ../Tests/Resource/ABLN_STMS.robot
Test Tags    ABB_STMS
Suite Setup    ABLN_STMS.System Logon
Suite Teardown   ABLN_STMS.System Logout

*** Test Cases ***
STMS_ABLN
    STMS_ABLN
