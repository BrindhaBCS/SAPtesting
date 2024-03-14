*** Settings ***
Resource    ../Tests/Resource/DBCO.robot
Suite Setup    DBCO.System Logon
Suite Teardown    DBCO.System Logout 
Test Tags    DBCO_ST

*** Test Cases ***
DBCO
    DBCO