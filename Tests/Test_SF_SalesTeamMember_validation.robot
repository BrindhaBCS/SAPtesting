*** Settings ***
Resource    ../Tests/Resource/SF_salesTeamMember_validation.robot
Test Tags    SF_salesTeamMember_validation
*** Test Cases ***
Login page
    Login Page

validation of mobile and email
    validation of mobile and email

sales_team
    sales_team

Lead validation
    NEW LEAD

sales team validation
    sales team validation