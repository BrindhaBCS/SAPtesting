*** Settings ***
Resource    ../Tests/Resource/Fiori_Step3.robot
Suite Setup    Fiori_Step3.System Logon
Suite Teardown    Fiori_Step3.System Logout 
Test Tags    report_123
*** Test Cases ***
Error_Capturing
    Error_Capturing
    Deletefile