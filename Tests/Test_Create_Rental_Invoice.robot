*** Settings ***
Resource    ../Tests/Resource/create_rental_invoice.robot 
Suite Setup    create_rental_invoice.System Logon
Suite Teardown    create_rental_invoice.System Logout
<<<<<<< HEAD
Task Tags    VF01
=======
Test Tags    VA42
>>>>>>> 4f47b324010fa1405a8efa60c932a7715c472418
 
 
*** Test Cases ***
Create the rental Invoice
    Rental Invoice