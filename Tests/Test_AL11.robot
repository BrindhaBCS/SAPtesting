*** Settings ***
Resource    ../Tests/Resource/AL11.robot
Force Tags    Al11
Suite Setup    AL11.System Logon
Suite Teardown    AL11.System Logout

  
*** Test Cases ***

Executing AL11
    Transaction AL11