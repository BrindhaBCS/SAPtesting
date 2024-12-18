*** Settings ***
Resource    ../Tests/Resource/ABLN_PRE_SE16.robot
Test Tags    pre_se16_Abinbev
Suite Setup    ABLN_PRE_SE16.System Logon


*** Test Cases ***
login
   # System Logon
   Pre_SE16
   Download the table
