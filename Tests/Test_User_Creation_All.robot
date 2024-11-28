*** Settings ***
Resource    ../Tests/Resource/User_Creation_All.robot
Force Tags   SU01_All
Suite Setup    User_Creation_All.System Logon
Suite Teardown    User_Creation_All.System Logout
 
*** Test Cases ***
Create User for ALM Configuration
    Create User