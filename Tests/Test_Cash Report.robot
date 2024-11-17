*** Settings ***
Resource    ../Tests/Resource/Cash Report.robot
Suite Setup    Cash Report.Login
Suite Teardown    Cash Report.Logout
Test Tags    CR

*** Test Cases ***
Cash Report
    Cash Report