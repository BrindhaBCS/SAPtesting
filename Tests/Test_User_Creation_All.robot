*** Settings ***
Resource    ../Tests/Resource/User_Creation.robot
Force Tags   SU01_All
Suite Setup    User_Creation.System Logon
Suite Teardown    User_Creation.System Logout
 
*** Test Cases ***
Create User for ALM Configuration
    Create User