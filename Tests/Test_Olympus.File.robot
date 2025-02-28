*** Settings ***
Resource    ../Tests/Resource/AL11_Olympus.robot
Test Tags    Olympus_al11 
Suite Setup    AL11_Olympus.System Logon
Suite Teardown    AL11_Olympus.System Logout
 
*** Test Cases ***
Executing Olympus AL11
    Executing Olympus AL11