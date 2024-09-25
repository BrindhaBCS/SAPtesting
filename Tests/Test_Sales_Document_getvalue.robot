*** Settings ***
Resource    ../Tests/Resource/Sales_Document_getvalue.robot
Suite Setup    Sales_Document_getvalue.System Logon
Suite Teardown    Sales_Document_getvalue.System Logout
Task Tags    SalesDocument_getvalue
 
 
*** Test Cases ***
Sales Document get value
    Sales Document get value