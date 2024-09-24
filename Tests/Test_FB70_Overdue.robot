*** Settings ***
Resource    ../Tests/Resource/FB70_Overdue.robot
Force Tags    FB70_Overdue
Suite Setup    FB70_Overdue.System Logon
Suite Teardown    FB70_Overdue.System Logout
  
*** Test Cases ***
checking for Customer Overdue
    checking for Customer Overdue
