*** Settings ***
Resource    ../Tests/Resource/Authorization profiles maintenance.robot
Suite Setup    Authorization profiles maintenance.System Logon
Suite Teardown    Authorization profiles maintenance.System Logout
Test Tags    Authorization_profiles_maintenance

*** Test Cases ***
Authorization profiles maintenance
    Authorization profiles maintenance