*** Settings ***
Resource    ../Tests/Resource/Usercontrol (non)personal user accounts.robot
Suite Setup    Usercontrol (non)personal user accounts.System Logon
Suite Teardown   Usercontrol (non)personal user accounts.System Logout
Test Tags    Usercontrol_nonpersonal_user_accounts

*** Test Cases ***
Usercontrol (non)personal user accounts
    Usercontrol (non)personal user accounts
Generate report
    Generate report