*** Settings ***
Resource    ../Tests/Resource/STMS_IMPORT.robot
Test Tags    stms_import_heineken
Suite Setup   STMS_IMPORT.System Logon
Suite Teardown   STMS_IMPORT.System Logout

*** Test Cases ***
STMS_import
    STMS_import