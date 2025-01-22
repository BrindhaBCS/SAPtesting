
*** Settings ***
Resource    ../Tests/Resource/Change_Date_Fiori_step1.robot
Suite Teardown  Change_Date_Fiori_step1.System Logout
Task Tags    fiori_test_Step_1
 
 
*** Test Cases ***
Fiori_T_CODE
   Fiori_System Logon