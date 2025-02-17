*** Settings ***
Resource    ../Tests/Resource/Rpa_scenario_deliverynumber.robot
Suite Setup    Rpa_scenario_deliverynumber.System Logon
Test Tags    rpa_delivery_sym

*** Test Cases ***
Vehicle_number_plate
    Vehicle_number_plate
    Run Keyword And Ignore Error    System Logout