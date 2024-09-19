*** Settings ***
Resource    ../Tests/Resource/SalesDocument.robot
Suite Setup    SalesDocument.System Logon
Suite Teardown    SalesDocument.System Logout
Task Tags    SalesDocument
 
 
*** Test Cases ***
Sales Document with CreditBlocks
    Sales Document with CreditBlocks