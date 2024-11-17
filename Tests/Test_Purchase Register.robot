*** Settings ***
Resource    ../Tests/Resource/Purchase Register.robot
# Suite Setup    Invoice_Overdue.Login
# Suite Teardown    Invoice_Overdue.Logout
Test Tags    PR

*** Test Cases ***
Purchase Register
    Purchase Register