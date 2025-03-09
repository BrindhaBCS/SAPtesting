*** Settings ***
Resource    ../Tests/Resource/ASN_material_quantity.robot
Suite Setup    ASN_material_quantity.System Logon
# Suite Teardown    ASN_material_quantity.System Logout
Test Tags    rpa_asnmaterial_sym

*** Test Cases ***
Material_code_quantity_from_ASN
    Material_code_quantity_from_ASN