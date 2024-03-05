*** Settings ***
Resource    ../Tests/Resource/Kernel_info_SM51_REFRESH.robot   
Suite Setup    Kernel_info_SM51_REFRESH.System Logon
Suite Teardown    Kernel_info_SM51_REFRESH.System Logout
Task Tags    Kernal_info
 
 
*** Test Cases ***
Kernel_info_SM51_T_CODE
    Kernel_info_SM51_T_CODE