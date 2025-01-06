*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_SM61.robot
Test Tags    ABLN_PRE_SM61
Suite Setup    ABLN_PRE_SM61.System Logon
Suite Teardown  ABLN_PRE_SM61.System Logout    

*** Test Cases ***
SM61_ABLN
    SM61_ABLN