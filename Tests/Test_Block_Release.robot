*** Settings ***
Resource    ../Tests/Resource/Block_Release.robot 
# Suite Setup    VA42.System Logon
Suite Teardown    Block_Release.System Logout
Task Tags    block_release
 
 
*** Test Cases ***
Releasing the contracts blocks
    System Logon