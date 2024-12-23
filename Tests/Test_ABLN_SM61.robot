*** Settings ***
Resource    ../Tests/Resource/ABLN_SM61.robot
Test Tags    ABB_SM61
Suite Setup    ABLN_SM61.System Logon
Suite Teardown  ABLN_SM61.System Logout

*** Test Cases ***
SM61_ABLN
    SM61_ABLN
