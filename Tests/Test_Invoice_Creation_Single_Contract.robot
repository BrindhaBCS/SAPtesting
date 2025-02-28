*** Settings ***
Resource    ../Tests/Resource/Invoice_Creation_Single_Contract.robot 
# Suite Setup    create_rental_invoice.System Logon
Suite Teardown    Invoice_Creation_Single_Contract.System Logout
Task Tags    rental_invoice
 
*** Test Cases ***
Create the rental Invoice
    Create Rental Invoice and download pdf