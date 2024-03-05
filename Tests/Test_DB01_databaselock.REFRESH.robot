*** Settings ***
Resource    ../Tests/Resource/DB01_databaselock.REFRESH.robot
Suite Setup    DB01_databaselock.REFRESH.System Logon
Suite Teardown    DB01_databaselock.REFRESH.System Logout
Task Tags    DB01_databaselock
 
 
*** Test Cases ***
scenario-databaselock
    scenario-databaselock