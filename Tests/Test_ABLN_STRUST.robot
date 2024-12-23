*** Settings ***
Resource    ../Tests/Resource/ABLN_STRUST.robot
Test Tags    ABB_STRSUT
Suite Setup    ABLN_STRUST.System Logon
Suite Teardown   ABLN_STRUST.System Logout

*** Test Cases ***
ABB_STRUST
    ABB_STRUST
    System PSE 
    SSL Server Standard
    SSL Client Anonymous
    SSL Client Standard
    SSF service Provider
    SSF Service Provider1
