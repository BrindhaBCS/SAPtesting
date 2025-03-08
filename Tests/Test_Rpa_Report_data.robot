*** Settings ***
Resource    ../Tests/Resource/Rpa_Report_data.robot
Suite Setup    Rpa_Report_data.System Logon
Suite Teardown    Rpa_Report_data.System Logout
Test Tags    Rpa_Report_data_sym

*** Test Cases ***
Report_data_sym_one
    Report_data_sym