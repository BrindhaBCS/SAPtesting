*** Settings ***
Resource    ../Tests/Resource/ABLN_SM13.robot
Test Tags    ABB_SM13
Suite Setup    ABLN_SM13.System Logon
Suite Teardown  ABLN_SM13.System Logout

*** Test Cases ***
SM13_ABLN
    SM13_ABLN
