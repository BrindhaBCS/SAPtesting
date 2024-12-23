*** Settings ***
Resource    ../Tests/Resource/ABLN_POST_SE16.robot
Test Tags    ABLN_POST_SE16

*** Test Cases ***
login
   System Logon
   Post_SE16