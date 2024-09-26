*** Settings ***
Resource    ../Tests/Resource/MRBR_Block.robot 
Suite Setup    MRBR_Block.System Logon
Suite Teardown    MRBR_Block.System Logout
Task Tags    MRBR_Block_Released
 
*** Test Cases ***
MRBR_Block
    MRBR_Block