*** Settings ***
Resource    ../Tests/Resource/Autorisaties SAP Query MCR.robot
Suite Setup    Autorisaties SAP Query MCR.System Logon
Suite Teardown    Autorisaties SAP Query MCR.System Logout
Test Tags    SAP_Query

*** Test Cases ***
Autorisaties SAP Query
    Autorisaties SAP Query