*** Settings ***
Resource    ../Tests/Resource/Invoice_posting.robot
Suite Setup    Invoice_posting.System Logon
Suite Teardown    Invoice_posting.System Logout
Test Tags    Invoice_Posting

*** Test Cases ***
VF04
    VF04
    