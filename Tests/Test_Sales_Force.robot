
*** Settings ***

Resource    ../Tests/Resource/Sales_Force.robot
Force Tags    Sales
Suite Setup    Sales_Force.Launch Sales Force
Suite Teardown    Sales_Force.Close Sales Force
  
*** Test Cases ***
Searching for sales document
    Document Search
    