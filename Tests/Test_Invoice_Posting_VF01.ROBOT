*** Settings ***
Resource    ../Tests/Resource/Invoice_Posting_VF01.robot
Suite Setup    Invoice_Posting_VF01.System Logon
Suite Teardown    Invoice_Posting_VF01.System Logout
Test Tags    Invoice_Posting_VF01


*** Test Cases ***
VF01
    VF01