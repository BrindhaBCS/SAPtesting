*** Settings ***
Resource    ../Tests/Resource/Verify_Pre_requisite.robot
Force Tags   Pre_Req
Suite Setup    Verify_Pre_requisite.System Logon
Suite Teardown    Verify_Pre_requisite.System Logout

*** Test Cases ***
Verify the system is ready for ALM configuration
    SAP BASIS Release
    SAP UI Release
    Component ST-PI Version
    Verify parameter in RZ10
    STRUST
    SNOTE