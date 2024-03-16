*** Settings ***
Resource    ../Tests/Resource/SMW0.robot
Suite Setup    SMW0.System Logon
Suite Teardown    SMW0.System Logout
Test Tags    SMW0_ST  

*** Test Cases ***
Transaction SMW0 
    SMW0
    Binarydata SMW0

