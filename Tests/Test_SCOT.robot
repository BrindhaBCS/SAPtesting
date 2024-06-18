*** Settings ***
Resource    Resource/SCOT.robot
Force Tags    SCOT
Suite Setup    SCOT.System Logon
Suite Teardown    SCOT.System Logout

*** Test Cases ***

Executing SCOT            
    Transaction SCOT
    #SMTP Nodes    
    #Settings Nodes
  
