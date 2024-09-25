*** Settings ***
Resource    ../Tests/Resource/Sales_Document.robot
Suite Setup    Sales_Document.System Logon
Suite Teardown    Sales_Document.System Logout
Task Tags    SalesDocument
 
 
*** Test Cases ***
Sales Document with CreditBlocks
    Sales Document with CreditBlocks