*** Settings ***    
Resource   ../Tests/Resource/MIGO103.robot
Test Tags    MIGO103
Suite Setup    MIGO103.SAP_LOGIN
Suite Teardown   MIGO103.close

*** Test Cases ***
login
    # SAP_LOGIN
    MMIGO103
    # close