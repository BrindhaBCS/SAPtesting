*** Settings ***
Resource    ../Tests/Resource/MIRO_PostParked.robot
Suite Setup    MIRO_PostParked.System Logon
# Suite Teardown    MIRO_PostParked.System Logout
Test Tags    MIRO_PostParked
 
 
*** Test Cases ***
MIRO Post Parked
    MIRO Post Parked