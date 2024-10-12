*** Settings ***
Resource    ../Tests/Resource/Control blocking transactions.robot
Suite Setup    Control blocking transactions.System Logon
Suite Teardown    Control blocking transactions.System Logout
Test Tags    Control_blocking_transactions

*** Test Cases ***
Control blocking transactions
    Control blocking transactions
    
    
    