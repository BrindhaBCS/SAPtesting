*** Settings ***
Resource    ../Tests/Resource/Rpa_Bin_allocation.robot
Suite Setup    Rpa_Bin_allocation.System Logon
Suite Teardown    Rpa_Bin_allocation.System Logout
Test Tags    BIN_Allocation_sym

*** Test Cases ***
BIN_Allocation
    BIN_Allocation