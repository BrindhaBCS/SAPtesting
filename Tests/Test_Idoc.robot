*** Settings ***
Resource    ../Tests/Resource/Idoc.robot
Force Tags   Idoc
Suite Setup    Idoc.System Logon
Suite Teardown    Idoc.System Logout
 
*** Test Cases ***
Check Idoc status
    Check Idoc status
    