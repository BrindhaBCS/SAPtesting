*** Settings ***
Resource    ../Tests/Resource/Invoice_Overdue.robot
# Suite Setup    Invoice_Overdue.Login
# Suite Teardown    Invoice_Overdue.Logout
Test Tags    IO

*** Test Cases ***
Start And Use Tally
    Start And Use Tally
