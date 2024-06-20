*** Settings ***
Resource   ../Tests/Resource/Role_configuration.robot
Test Tags    role_configuration

*** Test Cases ***
Start TestCase
    Start TestCase

Submit Anugal username and password
    Submit Anugal username and password

Role_configuartion
    Role_configuartion  
    Provisioning the role
    View the role
    Edit the role
    Delete the role

Finish TestCase 
    Finish TestCase    
