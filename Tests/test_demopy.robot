*** Settings ***
Resource    ../Tests/Resource/newdemo.robot
Suite Setup    newdemo.SAP Logon
Suite Teardown    newdemo.SAP Logout
Test Tags    newdemo

*** Test Cases ***
transaction validation
    Transaction Validation
    

