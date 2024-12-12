*** Settings ***
Resource    ../Tests/Resource/pre_SE16.robot
Test Tags    pre_se16_Abinbev

*** Test Cases ***
login
   System Logon
   Pre_SE16
