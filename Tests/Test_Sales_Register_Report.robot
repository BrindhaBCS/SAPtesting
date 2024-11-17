*** Settings ***
Resource    ../Tests/Resource/Sales_Register_Report.robot
# Suite Setup    Sales_Register_Report.Login
# Suite Teardown    Sales_Register_Report.Logout
Test Tags    SR

*** Test Cases ***
View Sales Register report
    Display sales register