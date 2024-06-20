*** Settings ***
Resource    ../Tests/Resource/User_Administration.robot

Test Tags    Create_user

*** Test Cases ***
Start TestCase
    Start TestCase

Submit Anugal username and password
    Submit Anugal username and password  

Create User_id
    Create User_id 
    View the User id 
    Edit the User id 
    Delete user id  

Finish TestCase 
    Finish TestCase         