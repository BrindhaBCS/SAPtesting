*** Settings ***
Resource    ../Tests/Resource/Idoc.robot
Force Tags   Idoc
Suite Setup    Idoc.System Logon
Suite Teardown    Idoc.System Logout
 
*** Test Cases ***
Re-execute the Idoc
    Execute Idoc