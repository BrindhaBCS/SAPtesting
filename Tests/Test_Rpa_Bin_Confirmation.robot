*** Settings ***
Resource    ../Tests/Resource/Rpa_Bin_Confirmation.robot
Suite Setup    Rpa_Bin_Confirmation.System Logon
Suite Teardown    Rpa_Bin_Confirmation.System Logout
Test Tags    Bin_Confirmation_sym

*** Test Cases ***
Rpa_Bin_Confirmation
    BIN_Conformation