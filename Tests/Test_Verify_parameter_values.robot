*** Settings ***
Resource    ../Tests/Resource/Verify_parameter_values.robot
Force Tags   verifyparam
Suite Setup    Verify_parameter_values.System Logon
Suite Teardown    Verify_parameter_values.System Logout
 
*** Test Cases ***
Verifying SAP Parameter values
    Verify parameter in RZ10