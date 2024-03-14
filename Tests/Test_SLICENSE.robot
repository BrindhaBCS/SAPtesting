*** Settings ***
Resource    ../Tests/Resource/SLICENSE.robot
Suite Setup    SLICENSE.System Logon
Suite Teardown    SLICENSE.System Logout 
Test Tags    SLICENSE_ST

*** Test Cases ***
SLICENSE
    SLICENSE