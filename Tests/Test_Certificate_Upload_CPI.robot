*** Settings ***
Resource    ../Tests/Resource/Certificate_Upload_CPI.robot
Suite Setup    Certificate_Upload_CPI.Browser Login
Suite Teardown    Certificate_Upload_CPI.Browser Logout
Test Tags    cert_upload
  
*** Test Cases ***
Certificate_upload
    Upload_Certificate