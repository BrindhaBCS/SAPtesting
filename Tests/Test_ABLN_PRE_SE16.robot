*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_SE16.robot
Test Tags    ABLN_PRE_SE16
Suite Setup    ABLN_PRE_SE16.System Logon


*** Test Cases ***
login
   # System Logon
   Pre_SE16
   Download the table
