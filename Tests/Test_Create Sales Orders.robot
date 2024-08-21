
*** Settings ***

Resource    ../Tests/Resource/VA01.robot
Force Tags    VA01
Suite Setup    VA01.System Logon
Suite Teardown    VA01.System Logout
  
*** Test Cases ***
Executing VA01
    Generate and Use Random Number
    Transaction VA01
    Selecting multiple materials
    