*** Settings ***
Resource    ../Tests/Resource/Audit log configuration.robot
Suite Setup    Audit log configuration.System Logon
Suite Teardown    Audit log configuration.System Logout
Test Tags    Audit_log_configuration

*** Test Cases ***
Audit log configuration
    Audit log configuration
    
    
    