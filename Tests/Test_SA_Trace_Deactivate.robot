*** Settings ***
Resource    ../Tests/Resource/SA_Trace_Deactivate.robot
Suite Setup    SA_Trace_Deactivate.System Logon
Suite Teardown    SA_Trace_Deactivate.System Logout
Test Tags    SA_Trace_Deactivate_sym

*** Test Cases ***
Trace_status
    Trace_status