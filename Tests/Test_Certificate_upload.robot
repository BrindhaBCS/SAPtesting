*** Settings ***
Resource    Resource/Certificate_upload.robot
Test Tags    cert_upload
Suite Setup    Certificate_upload.Browser Login
Suite Teardown    Certificate_upload.Browser Logout
  
*** Test Cases ***
Certificate_upload
    Uploading Certificate into SAP