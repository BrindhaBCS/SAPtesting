*** Settings ***
Resource    ../Tests/Resource/Execute_failed_rows_masterMaterial.robot
Suite Setup    Execute_failed_rows_masterMaterial.System Logon
# Suite Teardown    Execute_failed_rows_masterMaterial.System Logout
Test Tags    Material_Failed


*** Test Cases ***
Material_master
    # Material_master
    # Material_count 
    ReExecute_Failed_case