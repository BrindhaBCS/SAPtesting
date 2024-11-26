*** Settings ***
Resource    ../Tests/Resource/TR_CAPTURE_NIKE.robot   
Suite Setup    TR_CAPTURE_NIKE.System Logon
Suite Teardown    TR_CAPTURE_NIKE.System Logout
Task Tags    Tr_capture
 
 
*** Test Cases ***
TR_capture
    TR_capture