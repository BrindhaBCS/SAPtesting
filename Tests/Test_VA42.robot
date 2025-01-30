*** Settings ***
Resource    ../Tests/Resource/VA42.robot 
Task Tags    VA42_Block_details
 
 
*** Test Cases ***
Releasing the contracts blocks
    System Logon