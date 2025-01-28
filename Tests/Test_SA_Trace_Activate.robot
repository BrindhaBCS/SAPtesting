*** Settings ***
Resource    ../Tests/Resource/SA_Trace_Activate.robot
Suite Setup    SA_Trace_Activate.System Logon
Suite Teardown    SA_Trace_Activate.System Logout
Test Tags    SA_Trace_Activate_sym

*** Test Cases ***
Trace_status
    Trace_status