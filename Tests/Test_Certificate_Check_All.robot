*** Settings ***
Resource    ../Tests/Resource/Certificate_Check_All.robot
Test Tags    Certificate_Check_All
Suite Setup    Certificate_Check_All.System Logon
Suite Teardown    Certificate_Check_All.System Logout
*** Test Cases ***
Download Certificates
    Download Certificates
    STRUST
    