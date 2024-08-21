
*** Settings ***

Resource    ../Tests/Resource/VA03.robot
Force Tags    VA03
Suite Setup    VA03.System Logon
Suite Teardown    VA03.System Logout
  
*** Test Cases ***
Executing VA03
    Verify idoc
    