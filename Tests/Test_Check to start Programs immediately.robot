*** Settings ***
Resource    ../Tests/Resource/Check to start Programs immediately.robot
Suite Setup    Check to start Programs immediately.System Logon
Suite Teardown    Check to start Programs immediately.System Logout
Test Tags    Start_programs

*** Test Cases ***
Check to start Programs immediately
    Check to start Programs immediately
Generate report
    Generate report
    
    