*** Settings ***
Resource    ../Tests/Resource/Installed_Software_component_SM51_REFRESH.robot 
Suite Setup    Installed_Software_component_SM51_REFRESH.System Logon
Suite Teardown    Installed_Software_component_SM51_REFRESH.System Logout
Task Tags    Installed_Software_component_SM51_REFRESH

*** Test Cases ***
Installed_Software_component_Version_SM51_T_CODE
    Installed_Software_component_Version_SM51_T_CODE