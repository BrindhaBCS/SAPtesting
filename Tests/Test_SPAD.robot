*** Settings ***
Resource    ../Tests/Resource/SPAD_Olympus.robot
Test Tags    SPAD_Olympus   
Suite Setup    SPAD_Olympus.System Logon
Suite Teardown    SPAD_Olympus.System Logout
  
*** Test Cases ***
SPAD
    SPAD

SPAD_Outputdevices
    SPAD_Outputdevices
SPAD_Spoolservers
    SPAD_Spoolservers
SPAD_Accessmethods
    SPAD_Accessmethods
SPAD_Destinationhost
    SPAD_Destinationhost
