*** Settings ***
Resource    ../Tests/Resource/Generate_Purchase_Order.robot
# Suite Setup    Generate_Purchase_Order.Login
# Suite Teardown    Generate_Purchase_Order.Logout
Test Tags    PO

*** Test Cases ***
Display the outstanding purchase order
    Display the outstanding purchase order