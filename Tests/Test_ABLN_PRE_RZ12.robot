*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_RZ12.robot
Test Tags    Pre_ABB_RZ12
Suite Setup    ABLN_PRE_RZ12.System Logon
Suite Teardown   ABLN_PRE_RZ12.System Logout

*** Test Cases ***
RZ12
    RZ12
    Select Table Data
