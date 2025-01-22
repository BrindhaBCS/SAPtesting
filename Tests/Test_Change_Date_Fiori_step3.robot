
*** Settings ***
Resource    ../Tests/Resource/Change_Date_Fiori_step3.robot
Suite Setup    Change_Date_Fiori_step3.System Logon
Suite Teardown    Change_Date_Fiori_step3.System Logout
Test Tags    Fiori_step_3
*** Test Cases ***
Error_Capturing
    Error_Capturing