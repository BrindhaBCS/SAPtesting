*** Settings ***
Resource    ../Tests/Resource/Copilot_BIS_SAP.robot
Suite Setup    Copilot_BIS_SAP.System Logon
Suite Teardown    Copilot_BIS_SAP.System Logout 
Test Tags    snote_bis

*** Test Cases ***
Report_Table_BIS
    Report_Table_BIS
Output_BIS
    Output_BIS
Deletefile_BIS
    Deletefile_BIS