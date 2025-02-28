*** Settings ***
Resource    ../Tests/Resource/Salesforce_CreateLead_Login.robot
Test Tags    singleleadcreation
*** Test Cases ***
Create_Lead_login
    Create_Lead_login