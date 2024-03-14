*** Settings ***
Resource    ../Tests/Resource/BD97.robot
Suite Setup    BD97.System Logon
Suite Teardown    BD97.System Logout 
Test Tags    BD97_ST

*** Test Cases ***
BD97
    BD97