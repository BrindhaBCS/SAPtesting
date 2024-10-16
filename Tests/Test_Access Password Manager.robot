*** Settings ***
Resource    ../Tests/Resource/Access Password Manager.robot
Suite Setup    Access Password Manager.System Logon
Suite Teardown    Access Password Manager.System Logout
Test Tags    Access_Password_Manager

*** Test Cases ***
Access Password Manager
    Access Password Manager
Generate report
    Generate report
    

    