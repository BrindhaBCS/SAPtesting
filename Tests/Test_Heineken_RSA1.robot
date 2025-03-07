*** Settings ***
Resource    ../Tests/Resource/Heineken_RSA1.robot
Suite Setup   Heineken_RSA1.System Logon
Suite Teardown   Heineken_RSA1.System Logout
Test Tags    RSA1_1

*** Test Cases ***
check_RSA1
    RSA1