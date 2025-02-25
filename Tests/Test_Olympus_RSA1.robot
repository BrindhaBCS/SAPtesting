*** Settings ***
Resource    ../Tests/Resource/Olympus_RSA1.robot
# Suite Setup    Olympus_SM51.System Logon
# Suite Teardown   Olympus_SM51.System Logout
Test Tags    RSA1

*** Test Cases ***
RSA1
    RSA1