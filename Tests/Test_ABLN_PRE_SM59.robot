*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_SM59.robot
Test Tags    Pre_ABB_SM59
Suite Setup    ABLN_PRE_SM59.System Logon
Suite Teardown   ABLN_PRE_SM59.System Logout

*** Test Cases ***
ABB_SM59
    ABB_SM59
