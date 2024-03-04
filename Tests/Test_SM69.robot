*** Settings ***
Resource    Resource/SM69.robot
Force Tags    SM69
Suite Setup    SM69.System Logon
Suite Teardown    SM69.System Logout


*** Test Cases ***

Executing SM69

    Transaction SM69
    External Operating System Commands 
    SM69 Scroll 