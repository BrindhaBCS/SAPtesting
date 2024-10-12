*** Settings ***
Resource    ../Tests/Resource/Emergency User Edition.robot
Suite Setup    Emergency User Edition.System Logon
Suite Teardown   Emergency User Edition.System Logout
Test Tags    Emergency_User_Edition

*** Test Cases ***
Emergency User Edition
    Emergency User Edition