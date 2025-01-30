*** Settings ***
Resource    ../Tests/Resource/VA42.robot 
Task Tags    VA42
 
 
*** Test Cases ***
Releasing the contracts blocks
    System Logon