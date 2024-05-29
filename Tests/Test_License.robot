
*** Settings ***
Resource    ../Tests/Resource/License.robot
Suite Setup    License.System Logon
Suite Teardown    License.System Logout
Task Tags    License
 
 
*** Test Cases ***
License
    License Key
    Apply License
    # Login Box
