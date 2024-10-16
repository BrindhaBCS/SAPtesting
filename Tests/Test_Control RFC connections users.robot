*** Settings ***
Resource    ../Tests/Resource/Control RFC connections users.robot
Suite Setup    Control RFC connections users.System Logon
Suite Teardown    Control RFC connections users.System Logout
Test Tags    Control_RFC_connections_users

*** Test Cases ***
Control RFC connections users
    Control RFC connections users
Generate report
    Generate report
    
    
    