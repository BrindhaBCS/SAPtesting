*** Settings ***
Resource    ../Tests/Resource/Copilot_ABB_SAP.robot
Suite Setup    Copilot_ABB_SAP.System Logon
Suite Teardown    Copilot_ABB_SAP.System Logout 
Test Tags    snote_abb

*** Test Cases ***
Report_Table_ABB
    Report_Table_ABB
Output_ABB
    Output_ABB
Deletefile_ABB
    Deletefile_ABB