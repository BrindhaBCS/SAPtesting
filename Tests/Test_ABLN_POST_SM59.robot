*** Settings ***
Resource    ../Tests/Resource/ABLN_POST_SM59.robot
Test Tags    Post_ABB_SM59
Suite Setup    ABLN_POST_SM59.System Logon
Suite Teardown   ABLN_POST_SM59.System Logout

*** Test Cases ***
ABB_SM59
    ABB_SM59
