*** Settings ***
Resource    ../Tests/Resource/Role_Temporarydata.robot
Suite Setup    Role_Temporarydata.System Logon
Suite Teardown    Role_Temporarydata.System Logout 
Test Tags    Role_Temporarydata_sym

*** Test Cases ***
Role_Temporarydata
    Get_Temporarydata