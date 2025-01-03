*** Settings ***
Resource    ../Tests/Resource/Verify_parameter_values_All.robot
Force Tags   verifyparam_ALL
Suite Setup    Verify_parameter_values_All.System Logon
Suite Teardown    Verify_parameter_values_All.System Logout
 
*** Test Cases ***
Verifying SAP Parameter values
    Verify parameter in RZ10