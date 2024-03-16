*** Settings ***
Resource    ../Tests/Resource/SECSTORE.robot
Suite Setup    SECSTORE.System Logon
Suite Teardown    SECSTORE.System Logout 
Test Tags    SECSTORE_ST

*** Test Cases ***
Transaction SECSTORE
    SECSTORE