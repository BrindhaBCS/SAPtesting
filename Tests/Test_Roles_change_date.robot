*** Settings ***
Resource    ../Tests/Resource/Roles_Change_date.robot
Suite Setup    Roles_Change_date.System Logon
Suite Teardown    Roles_Change_date.System Logout
Test Tags    Roles_Change_date

*** Test Cases ***
Change_Date
    Change_Date
    Deletefile