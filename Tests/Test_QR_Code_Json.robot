*** Settings ***
Resource    ../Tests/Resource/QR_Code_Json.robot
Suite Setup    QR_Code_Json.System Logon
Suite Teardown    QR_Code_Json.System Logout
Test Tags    QR_Code_sym

*** Test Cases ***
Qr_code_json
    Qr_code