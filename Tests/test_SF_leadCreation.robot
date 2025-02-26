*** Settings ***
Resource    ../Tests/Resource/SF_leadCreation.robot
Test Tags    SF_leadCreation
*** Test Cases ***
Login page
    Login Page
validation of mobile and email
    validation of mobile and email
lead creation
    Lead creation