*** Settings ***
Resource    ../Tests/Resource/Control table logging.robot
Suite Setup    Control table logging.System Logon
Suite Teardown    Control table logging.System Logout
Test Tags    Control_table_logging

*** Test Cases ***
Control table logging
    Control table logging
Generate report
    Generate report
    
    
    