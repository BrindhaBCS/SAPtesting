*** Settings ***
Resource    ../Tests/Resource/Release Debug Privilege on Production.robot
Suite Setup    Release Debug Privilege on Production.System Logon
Suite Teardown    Release Debug Privilege on Production.System Logout
Test Tags    Release_Debug

*** Test Cases ***
Release Debug Privilege on Production
    Release Debug Privilege on Production
Generate report
    Generate report