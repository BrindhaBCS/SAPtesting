*** Settings ***
Resource    ../Tests/Resource/Rpa_Gr_allocation.robot
Suite Setup    Rpa_Gr_allocation.System Logon
Suite Teardown    Rpa_Gr_allocation.System Logout
Test Tags    GR_Allocation_sym

*** Test Cases ***
GR_Allocation
    GR_Allocation