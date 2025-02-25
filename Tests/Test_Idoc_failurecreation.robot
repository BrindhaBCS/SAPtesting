*** Settings ***
Resource    ../Tests/Resource/Idoc_failurecreation.robot
Force Tags   idoc_failue
Suite Setup    Idoc_failurecreation.System Logon
Suite Teardown    Idoc_failurecreation.System Logout
 
*** Test Cases ***
Changing_Port
    Changing_Port
    Creating_PO