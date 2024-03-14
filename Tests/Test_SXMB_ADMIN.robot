*** Settings ***
Resource    ../Tests/Resource/SXMB_ADMIN.robot
Suite Setup    SXMB_ADMIN.System Logon
Suite Teardown    SXMB_ADMIN.System Logout 
Test Tags    SXMB_ADMIN_ST

*** Test Cases ***
SXMB_ADMIN
    SXMB_ADMIN