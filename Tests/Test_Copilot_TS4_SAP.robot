*** Settings ***
Resource    ../Tests/Resource/Copilot_TS4_SAP.robot
Suite Setup    Copilot_TS4_SAP.System Logon
Suite Teardown    Copilot_TS4_SAP.System Logout 
Test Tags    snote_ts4

*** Test Cases ***
Report_Table_TS4
    Report_Table_TS4
Output
    Output
Deletefile
    Deletefile