*** Settings ***
Resource    ../Tests/Resource/Makeittoday_ASN_material_quantity.robot
Suite Setup    Makeittoday_ASN_material_quantity.System Logon
Test Tags    RPA_Makeittoday_ASN_material_sym

*** Test Cases ***
Vehicle_number_plate
    Vehicle_number_plate
    Run Keyword And Ignore Error    System Logout