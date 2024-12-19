*** Settings ***
Resource    ../Tests/Resource/ABLN_POST_RZ12.robot
Test Tags    Post_ABB_RZ12
Suite Setup    ABLN_POST_RZ12.System Logon
Suite Teardown   ABLN_POST_RZ12.System Logout

*** Test Cases ***
RZ12
    RZ12
    Delete Logon Group
    Select Table Data
