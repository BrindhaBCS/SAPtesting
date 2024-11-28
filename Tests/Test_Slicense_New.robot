*** Settings ***
Resource    ../Tests/Resource/Slicense_New.robot
Test Tags    Slicense_New_Lamda
Suite Setup    Slicense_New.System Logon
Suite Teardown    Slicense_New.System Logout
*** Test Cases ***
slicense_Lamda
    slicense_Lamda