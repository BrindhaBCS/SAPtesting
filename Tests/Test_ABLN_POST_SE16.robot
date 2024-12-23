*** Settings ***
Resource    ../Tests/Resource/ABLN_POST_SE16.robot
Test Tags    ABLN_POST_SE16
Suite Setup    ABLN_POST_SE16.System Logon
Suite Teardown    ABLN_POST_SE16.close

*** Test Cases ***
login
   Post_SE16