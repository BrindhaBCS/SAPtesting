*** Settings ***
Resource    ../Tests/Resource/Installed_Product_version_SM51_REFRESH.robot 
Suite Setup    Installed_Product_version_SM51_REFRESH.System Logon
Suite Teardown    Installed_Product_version_SM51_REFRESH.System Logout
Task Tags    Installed_Product_version_SM51
 
 
*** Test Cases ***
Installed_Product_version_SM51_T_CODE
    Installed_Product_version_SM51_T_CODE
