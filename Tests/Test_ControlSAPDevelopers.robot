*** Settings ***
Resource    ../Tests/Resource/ControlSAPDevelopers.robot
Test Tags    CSD
Suite Setup    Control SAP developers.System Logon
Suite Teardown    ControlSAPDevelopers.System Logout

*** Test Cases ***
Control SAP developers
    Control SAP developers