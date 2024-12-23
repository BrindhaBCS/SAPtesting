*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_SE16.robot
Test Tags    ABLN_PRE_SE16
Suite Setup    ABLN_PRE_SE16.System Logon
Suite Teardown    ABLN_PRE_SE16.close


*** Test Cases ***
login
   Pre_SE16
   Download the table
