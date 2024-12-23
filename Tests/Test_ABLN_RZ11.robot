*** Settings ***
Resource    ../Tests/Resource/ABLN_RZ11.robot
Test Tags    ABB_RZ1
Suite Setup    ABLN_RZ11.System Logon
Suite Teardown   ABLN_RZ11.System Logout

*** Test Cases ***
ABB_RZ11
    ABB_RZ11
