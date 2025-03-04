*** Settings ***
Resource    ../Tests/Resource/SCC4.robot
Test Tags    scc4_heineken
Suite Setup   SCC4.System Logon
Suite Teardown   SCC4.System Logout

*** Test Cases ***
SCC4
    SCC4
