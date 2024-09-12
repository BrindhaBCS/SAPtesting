*** Settings ***
Resource    ../Tests/Resource/Certificate_Check.robot
Test Tags    Certificate_Check_
Suite Setup    Certificate_Check.System Logon
Suite Teardown    Certificate_Check.System Logout
*** Test Cases ***
Download Certificates
    Download Certificates
    STRUST
    